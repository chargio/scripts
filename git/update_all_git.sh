#!/bin/bash

# A script to update all directories below a given one.
# It looks for:
# If the remotes are configured as upstream and origin, it will fetch all branches upstream,
# checkout master, merge upstream/master on it, and update origin with the new code.
# If the remote, however, does not have upstream, it will pull the current branch from origin (keep it all together)
#
# Modified from pieces in stackoverflow

# Uses STASH to know whethere there is a need for stashing changes before updating


# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo -e "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"
#!/bin/bash

# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo -e "\n\033[1mPulling in latest changes for all repositories (master branch)...\033[0m\n"

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" | cut -c 3-); do
    echo "";
    echo -e "\033[33m"+$i+"\033[0m";

    # We have to go to the .git parent directory to call the pull command
    cd "$i";
    cd ..;

    if git remote get-url upstream
    then
      # get all branches
      git fetch --all
      # understand which branch are we in
      BRANCH=`git rev-parse --abbrev-ref HEAD`
      # change to master
      git checkout master
      # make sure NEED_TO_STASH is not set
      unset NEED_TO_STASH
      git stash
      if [ $? -eq 0 ]; then STASH="true"; fi
      git merge upstream/master --ff-only
      # and push it to the origin branch;
      git push --mirror
      # go to the original branch
      git checkout $BRANCH
      if [ $NEED_TO_STASH ]; then git stash pop; unset NEED_TO_STASH; fi
    else
      # No upstream is present, so no coding is involved, copy repository
      # pull origin
      git fetch --all
      # merge current branch
      git pull
    fi
    # lets get back to the CUR_DIR
    cd $CUR_DIR
done

echo -e "\n\033[32mComplete!\033[0m\n"
