#!/usr/bin/env bash

# requires curl

# Fetch the latest commit hash from Winds-Studio/Leaf and update gradle.properties
curl -s "https://api.github.com/repos/Winds-Studio/Leaf/commits" | \
grep -o '"sha": "[a-f0-9]\{40\}"' | \
head -n 1 | \
awk -F': ' '{print $2}' | \
tr -d '"' | \
xargs -I {} sed -i "s/^Commit =.*/Commit = {}/" gradle.properties

# Commit the change
git add gradle.properties
git commit -m "Update gradle.properties with the latest commit from Winds-Studio/Leaf"
