-- Database: ~/.config/mpv/listen_stats.db
-- Classification thresholds:
--   heard   >= 75%
--   partial  15% - 74%
--   skipped  < 15%

local DB_PATH = os.getenv("HOME") .. "/.config/mpv/listen_stats.db"

local function db_exec(sql)
    local escaped = sql:gsub("'", "'\\''")
    local cmd = string.format("sqlite3 '%s' '%s'", DB_PATH, escaped)
    local pipe = io.popen(cmd .. " 2>&1")

    if not pipe then
        mp.msg.error("[listen_stats] db_exec: failed to open pipe")
        return nil
    end

    local out = pipe:read("*a")
    pipe:close()

    if out and out ~= "" then
        mp.msg.warn("[listen_stats] sqlite3: " .. out)
    end
end

local function ensure_table()
    db_exec([[
        CREATE TABLE IF NOT EXISTS songs (
            id          INTEGER PRIMARY KEY,
            filename    TEXT UNIQUE NOT NULL,
            appearances INTEGER DEFAULT 0,
            heard       INTEGER DEFAULT 0,
            partial     INTEGER DEFAULT 0,
            skipped     INTEGER DEFAULT 0,
            total_sec   REAL    DEFAULT 0,
            last_played INTEGER
        );
    ]])
end

local current = {
    filename  = nil,
    start_pos = nil,
    duration  = nil,
    recorded  = false,
}

local function reset_state()
    current.filename  = nil
    current.start_pos = nil
    current.duration  = nil
    current.recorded  = false
end

local function record_appearance(fname)
    local now = os.time()

    local safe = fname:gsub("'", "''")

    db_exec(string.format([[
        INSERT OR IGNORE INTO songs (filename, appearances, last_played) VALUES
            ('%s', 0, %d);
        
        UPDATE songs
        SET appearances = appearances + 1, last_played = %d
        WHERE filename = '%s';
    ]], safe, now, now, safe))
end

local function record_result(fname, listened_secs, duration)
    if listened_secs < 0 then
        listened_secs = 0
    end

    local pct = (duration > 0) and (listened_secs / duration * 100) or 0
    local status

    if pct >= 75 then
        status = "heard"
    elseif pct < 15 then
        status = "skipped"
    else
        status = "partial"
    end

    local safe = fname:gsub("'", "''")
    db_exec(string.format([[
        UPDATE songs
        SET %s = %s + 1, total_sec = total_sec + %.3f
        WHERE filename = '%s';
    ]], status, status, listened_secs, safe))

    mp.msg.info(string.format("[listen_stats] %s: %s (%.0f%%)", status, fname, pct))
end

local function finalize(reason)
    if current.recorded then return end
    if not current.filename then return end

    local fname = current.filename
    local duration = current.duration

    if not duration or duration <= 0 then
        duration = mp.get_property_number("duration")
    end

    if not duration or duration <= 0 then
        mp.msg.warn(string.format("[listen_stats] skipping '%s' - duration unknown (%s)", fname, reason))
        current.recorded = true
        return
    end

    local pos = mp.get_property_number("time-pos") or current.start_pos or 0
    local start = current.start_pos or 0
    local listened_secs = math.max(0, pos - start)

    current.recorded = true
    record_result(fname, listened_secs, duration)
end

mp.register_event("file-loaded", function()
    if current.filename and not current.recorded then
        finalize("file-change")
    end

    reset_state()

    local fname = mp.get_property("filename/no-ext")
    if not fname or fname == "" then return end

    fname = fname:match("([^/\\]+)$") or fname

    current.filename = fname
    current.start_pos = mp.get_property_number("time-pos") or 0
    current.duration = mp.get_property_number("duration")

    if not current.duration or current.duration <= 0 then
        mp.observe_property("duration", "number", function(name, val)
            if val and val > 0 and not current.duration then
                current.duration = val
                mp.unobserve_property(name)
            end
        end)
    end

    ensure_table()
    record_appearance(fname)
end)

mp.register_event("end-file", function(event)
    if current.filename and not current.recorded then
        finalize("end-file:" .. (event.reason or "unknown"))    
    end
    reset_state()
end)

mp.register_event("shutdown", function()
    if current.filename and not current.recorded then
        finalize("shutdown")
    end
end)
