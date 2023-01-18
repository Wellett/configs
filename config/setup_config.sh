#! /bin/bash
# Basic installation script to automate configuration set-up
# Currently ripped almost straight from Atlassian

configURL="git@github.com:Wellett/configs.git"

wikiURL="git@github.com:Wellett/wiki.git"

# Set up configs Repo
git clone --bare $configURL $HOME/.config_repo

#set up wiki repo
git clone $wikiURL $HOME/vimwiki

function config {
   /usr/bin/git --git-dir=$HOME/.config_repo/ --work-tree=$HOME $@
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

#TODO
# should we source ~/.bashrc at the end of this so that aliases take effect?
# Do we need to?
# Can we change master to main?
