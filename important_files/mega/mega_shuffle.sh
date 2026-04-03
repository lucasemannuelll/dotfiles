#!/bin/bash

# 1. Your 20 custom prefixes/folders
prefixes=("alpha" "beta" "gamma" "delta" "epsilon" "zeta" "eta" "theta" "iota" "kappa" "titan" "vortex" "starlight" "nebula" "phantom" "echo" "cipher" "lunar" "flame" "obsidian")

SOURCE_DIR="Freak off/temp"
TARGET_BASE="Freak off/organized"

# 2. Ensure the organized structure is intact
echo "Verifying folder structure..."
for p in "${prefixes[@]}"; do
    mega-mkdir -p "$TARGET_BASE/$p"
done

# 3. Processing
echo "Checking $SOURCE_DIR for new files..."

# We use mega-ls -h to get the names
files=$(mega-ls -h "$SOURCE_DIR")

count=0
for filename in $files; do
    # Skip headers, empty lines, and the source folder itself
    [[ "$filename" == *":" ]] && continue
    [[ -z "$filename" ]] && continue
    [[ "$filename" == "temp" ]] && continue

    # Pick a random folder from the 20
    rand_idx=$(( RANDOM % 20 ))
    target_folder=${prefixes[$rand_idx]}
    
    # Execute Move (Keeping original filename)
    mega-mv "$SOURCE_DIR/$filename" "$TARGET_BASE/$target_folder/"
    
    echo "Moved: $filename -> $target_folder/"
    ((count++))
done

if [ $count -eq 0 ]; then
    echo "Temp is empty."
else
    echo "Successfully sorted $count files."
fi
