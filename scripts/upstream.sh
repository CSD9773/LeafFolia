#!/usr/bin/env bash

# requires curl

# Usage:
# leafCommit --leaf
# flag: --leaf - get the latest commit from Winds-Studio/Leaf and update gradle.properties

function getLatestCommit() {
    # Fetch the latest commit from Winds-Studio/Leaf and extract the commit hash using grep and awk
    curl -s "https://api.github.com/repos/Winds-Studio/Leaf/commits" | \
    grep -o '"sha": "[a-f0-9]\{40\}"' | \
    head -n 1 | \
    awk -F': ' '{print $2}' | \
    tr -d '"'
}

(
set -e
PS1="$"

# Get the latest commit hash from Winds-Studio/Leaf
latestCommitHash=$(getLatestCommit)

if [ -n "$latestCommitHash" ]; then
    # Directly update gradle.properties with the new commit hash
    sed -i "s/^-Commit =.*/-Commit = $latestCommitHash/" gradle.properties

    disclaimer="Updated to the latest commit from Winds-Studio/Leaf"
    log="Updated gradle.properties with the latest commit from Leaf ($latestCommitHash)\n\n${disclaimer}"

    git add gradle.properties
    echo -e "$log" | git commit -F -
else
    echo "Failed to fetch the latest commit hash from Winds-Studio/Leaf."
    exit 1
fi

) || exit 1
