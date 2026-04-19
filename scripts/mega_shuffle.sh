#!/bin/bash
set -euo pipefail
# ─── Config ──────────────────────────────────────────────────────────────────
prefixes=("alpha" "beta" "gamma" "delta" "epsilon" "zeta" "eta" "theta" "iota" "kappa"
          "titan" "vortex" "starlight" "nebula" "phantom" "echo" "cipher" "lunar" "flame" "obsidian")
SOURCE_DIR="Freak off/temp"
TARGET_BASE="Freak off/organized"
NUM_PREFIXES=${#prefixes[@]}
MAX_ITEMS=200
# ─────────────────────────────────────────────────────────────────────────────
if ! command -v mega-ls &>/dev/null; then
    echo "ERROR: megacmd is not installed or not in PATH." >&2
    exit 1
fi
if ! command -v rg &>/dev/null; then
    echo "ERROR: ripgrep is not installed or not in PATH." >&2
    exit 1
fi
# ─── Ensure folder structure ─────────────────────────────────────────────────
echo "Verifying folder structure..."
existing=$(mega-ls "$TARGET_BASE" 2>/dev/null || true)
for p in "${prefixes[@]}"; do
    if ! rg -qx "$p" <<< "$existing"; then
        mega-mkdir "$TARGET_BASE/$p"
    fi
done
# ─── Scan folder counts ONCE ─────────────────────────────────────────────────
declare -A folder_counts
eligible_folders=()

echo "Scanning folder counts (one-time)..."
for p in "${prefixes[@]}"; do
    item_count=$(mega-ls "$TARGET_BASE/$p" 2>/dev/null | wc -l)
    folder_counts["$p"]=$item_count
    if (( item_count < MAX_ITEMS )); then
        eligible_folders+=("$p")
    fi
    echo "  $p: $item_count items"
done

if [[ ${#eligible_folders[@]} -eq 0 ]]; then
    echo "WARNING: All folders are already at the $MAX_ITEMS item limit. Nothing to do." >&2
    exit 2
fi

echo "Eligible folders: ${#eligible_folders[@]}/${NUM_PREFIXES}"
# ─── Fisher-Yates-safe random index (from eligible array) ────────────────────
random_index() {
    local count=$1
    local max=$(( 32768 - (32768 % count) ))
    local r
    while true; do
        r=$RANDOM
        (( r < max )) && break
    done
    echo $(( r % count ))
}
# ─── Process files ───────────────────────────────────────────────────────────
echo "Checking $SOURCE_DIR for new files..."
moved=0
errors=0

while IFS= read -r filename; do
    filename="${filename%"${filename##*[![:space:]]}"}"  # trim trailing whitespace
    [[ -z "$filename" ]]         && continue
    [[ "$filename" == *: ]]      && continue
    [[ "$filename" == "temp" ]]  && continue

    # ── Check if any eligible folders remain ─────────────────────────────────
    if [[ ${#eligible_folders[@]} -eq 0 ]]; then
        echo "WARNING: All folders have reached the $MAX_ITEMS item limit. Stopping early." >&2
        break
    fi

    rand_idx=$(random_index "${#eligible_folders[@]}")
    target_folder="${eligible_folders[$rand_idx]}"

    if mega-mv "$SOURCE_DIR/$filename" "$TARGET_BASE/$target_folder/"; then
        echo "Moved: \"$filename\" -> $target_folder/"
        moved=$(( moved + 1 ))

        # ── Update local count; drop folder from eligible if now full ─────────
        folder_counts["$target_folder"]=$(( folder_counts["$target_folder"] + 1 ))
        if (( folder_counts["$target_folder"] >= MAX_ITEMS )); then
            echo "  [$target_folder] reached $MAX_ITEMS items — removing from pool."
            eligible_folders=("${eligible_folders[@]/$target_folder/}")
            # compact out the blank slot
            eligible_folders=("${eligible_folders[@]}")
        fi
    else
        echo "ERROR: Failed to move \"$filename\"" >&2
        errors=$(( errors + 1 ))
    fi
done < <(mega-ls "$SOURCE_DIR")
# ─── Summary ─────────────────────────────────────────────────────────────────
if [[ $moved -eq 0 && $errors -eq 0 ]]; then
    echo "Temp is empty — nothing to move."
else
    echo "Done. Moved: $moved  |  Errors: $errors"
fi
[[ $errors -gt 0 ]] && exit 1
exit 0
