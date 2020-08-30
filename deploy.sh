#!/bin/bash
msg_public_file=/d/Hugo/mand2_blog/msg/public.md
msg_blog_file=/d/Hugo/mand2_blog/msg/blog.md


echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg_public=`cat $msg_public_file`
git commit -m "$msg_public"

# Push source and build repos.
git push

# Come Back up to the Project Root
cd ..


# blog 저장소 Commit & Push
git add .

msg_blog=`cat $msg_blog_file`
git commit -m "$msg_blog"

git push