#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo

# Go To Public folder
cd public
git checkout master
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
echo -e "\033[0;32mPushing changes to remote repo...\033[0m"
git push origin master

# Come Back
cd ..
