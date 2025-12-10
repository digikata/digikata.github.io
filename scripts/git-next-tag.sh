#!/bin/sh

# Get current date in YYYY-MM-DD format
DATE=$(date +%Y-%m-%d)

# Base tag
BASE_TAG="pub-${DATE}"

# Find the next available tag
TAG="${BASE_TAG}"
N=1

# Check if base tag exists
if git rev-parse "${TAG}" >/dev/null 2>&1; then
    # If base tag exists, increment N until we find an unused tag
    while git rev-parse "${BASE_TAG}-${N}" >/dev/null 2>&1; do
        N=$((N + 1))
    done
    TAG="${BASE_TAG}-${N}"
fi

# Check if git is clean (uncommitted changes or untracked files)
if ! git diff-index --quiet HEAD -- 2>/dev/null || [ -n "$(git status --porcelain)" ]; then
    TAG="${TAG}-dirty"
fi

# Print the tag
echo "${TAG}"
