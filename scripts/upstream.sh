#!/usr/bin/env bash

branch="ver/1.21.1"

# Lấy commit hash mới nhất từ nhánh cụ thể
commitHash=$(curl -s "https://api.github.com/repos/Winds-Studio/Leaf/commits?sha=$branch" | \
grep -o '"sha": "[a-f0-9]\{40\}"' | \
head -n 1 | \
awk -F': ' '{print $2}' | \
tr -d '"')

if [ -n "$commitHash" ]; then
    sed -i "s/^-Commit =.*/-Commit = $commitHash/" gradle.properties
    git add gradle.properties
    git commit -m "Update Leaf commit from branch $branch: $commitHash"
else
    echo "❌ Failed to fetch latest commit from branch $branch"
    exit 1
fi
