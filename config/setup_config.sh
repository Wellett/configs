#! /bin/bash
# Basic installation script to automate configuration set-up
# Currently ripped almost straight from Atlassian

configURL="git@github.com:Wellett/configs.git"

git clone --bare $configURL $HOME/.config

function config {
   /usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME $@
}
mkdir -p config_backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} config_backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

# Remove config_backup if empty
rmdir --ignore-fail-on-non-empty config_backup 
