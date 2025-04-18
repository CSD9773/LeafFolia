#!/usr/bin/env bash

# requires curl

# Fetch the latest commit hash from Winds-Studio/Leaf and update gradle.properties
commitHash=$(curl -s "https://api.github.com/repos/Winds-Studio/Leaf/commits" | \
grep -o '"sha": "[a-f0-9]\{40\}"' | \
head -n 1 | \
awk -F': ' '{print $2}' | \
tr -d '"')

# Kiểm tra xem có commit hash hay không
if [ -n "$commitHash" ]; then
    # Chuyển file gradle.properties về định dạng Unix (LF) nếu nó đang có định dạng Windows (CRLF)
    dos2unix gradle.properties

    # Cập nhật gradle.properties với commit hash mới nhất
    sed -i "s/^Commit=.*/Commit=$commitHash/" gradle.properties

    # Commit thay đổi
    git add gradle.properties
    git commit -m "Update gradle.properties with the latest commit from Winds-Studio/Leaf"
else
    echo "Failed to fetch the latest commit hash."
    exit 1
fi
