# configs
A repository to store some dotfiles /configs etc. 
Still pretty much just learning how to set my stuff up like this

# Set up line
curl https://raw.githubusercontent.com/Wellett/configs/master/config/setup_config.sh | /bin/bash

# Troubleshooting
Issue #1  27Aug2021
 - Sometimes fetch/pull does not pull all remote branches
 - Root cause: remote references are not set up correctly
 - Fix: Add refs to .config/config 
    [remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
 - Solution to stop this from affecting all repos unkown 


