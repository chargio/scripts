#!/bin/bash

# A script to update all directories below a given one.
# It looks for:
# If the remotes are configured as upstream and origin, it will fetch all upstream, merge master, and update origin
# If the remote, however, does not have upstream, it will pull the current branch
# Modified from pieces in stackoverflow


# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo -e "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" | cut -c 3-); do
    echo "";
    echo -e "\033[33m"+$i+"\033[0m";

    # We have to go to the .git parent directory to call the pull command
    cd "$i";
    cd ..;

    if git remote get-url upstream
    then
      # finally pull
      git fetch --all
      git checkout master
      git merge upstream/master
      # and push it to the origin branch;
      git push;
    else
      # pull origin
      git pull
    fi

    # lets get back to the CUR_DIR
    cd $CUR_DIR
done

echo -e "\n\033[32mComplete!\033[0m\n"
