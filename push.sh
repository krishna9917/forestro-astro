#!/bin/bash

# Get the current branch name using a more compatible method
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check if we are in a git repository
if [ -z "$branch_name" ]; then
    echo "Not in a git repository or no branch found."
    exit 1
fi

# Add all changes
git add .

# Commit changes with a message
git commit -m "update"

# Push to the current branch
git push origin "$branch_name"
