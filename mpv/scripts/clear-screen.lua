function clear_and_show()
    os.execute("clear")

    local filename = mp.get_property("filename")
    print("▶ Now playing: " .. filename)
end

mp.register_event("file-loaded", clear_and_show)
