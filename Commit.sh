#!/bin/bash

# Change to the specified directory
cd ~/Minecraft/MCS-MCOL-Tv3.2 || exit

# Function to check for changes, commit, and push
commit_and_push() {
  # Add all changes, including untracked files
  git add -A

  # Check for changes to be committed
  if [[ `git status --porcelain` ]]; then
    # Commit changes with a message
    git commit -m "Automated commit"

    # Push changes to the remote repository using HTTP Basic Authentication
    git push https://USER:TOKEN@github.com/USER/MCS-MCOL-Tv3.2.git
  else
    echo "No changes to commit"
  fi
}

# Function to create release for the latest commit
create_release() {
  # Get the latest commit hash
  latest_commit=$(git rev-parse HEAD)

  # Get the latest commit message
  commit_message=$(git log -1 --pretty=%B)

  # Create a release with a readable tag name
  curl -X POST -H "Authorization: token TOKEN" -d "{\"tag_name\":\"v$(date +'%Y%m%d%H%M%S')\",\"name\":\"Release $(date +'%Y%m%d%H%M%S')\",\"body\":\"$commit_message\"}" https://api.github.com/repos/USER/MCS-MCOL-Tv3.2/releases
}

# Infinite loop
while true; do
  commit_and_push
  create_release
  # Wait for 5 minutes before checking again
  sleep 1
done
