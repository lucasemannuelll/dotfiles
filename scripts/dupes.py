import os
from collections import defaultdict

# Store filename -> list of paths
file_map = defaultdict(list)

# Read metadata.txt
with open('metadata.txt', 'r') as f:
    for line in f:
        path = line.strip()
        if path:
            filename = os.path.basename(path)
            file_map[filename].append(path)

# Delete duplicates (keep first, delete rest)
deleted = 0
for filename, paths in file_map.items():
    if len(paths) > 1:
        # Keep the first file, delete all others
        for path in paths[1:]:
            print(f"Deleting: {path}")
            os.system(f'mega-rm "{path}"')
            deleted += 1

print(f"\nDeleted {deleted} duplicate files")
