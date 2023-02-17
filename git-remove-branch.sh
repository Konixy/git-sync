#!/bin/bash

# Example branch name to remove
branch="$1"

if [ -z "$branch" ]; then
  echo -n "What branch would you like to delete? :"
  read -r branch
  if [ -z "$branch" ]; then echo "Invalid branch name"; exit 1; fi;
fi

# Check if the branch exists
if git show-ref --quiet --verify "refs/heads/$branch"; then
  # Delete the branch
  git branch -D "$branch"
  exit 0
else
  echo "Branch $branch does not exist"
fi