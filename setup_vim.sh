#! /usr/bash

# Basic setup
# TODO: add some command line options to make this more versatile

# Generic function to handle prompting the user
# This should be used for all verification interactions with the user
prompt() {
    echo "$1"
    read -rp "Do you want to continue? [y/n]" yes_or_no

    if [ "$yes_or_no" = "n" ]; then
        echo "NOTICE: Exiting"
        exit 0
    fi

    return 0
}

# Update files
git fetch
git pull origin master

if [ -d ~/.vim ]; then
    status=$(prompt "NOTICE: Found pre-existing vim directory at ~/.vim")

    if [ "$status" -eq "0" ]; then
        echo "NOTICE: Overwriting vim directory at ~/.vim"
        rm -rf ~/.vim
    fi
fi

# Copy files over
cp -r .vim/ ~/

if [ -e ~/.vimrc ]; then
    echo "NOTICE: Found pre-existing vimrc at ~/.vimrc; removing"
    rm -f ~/.vimrc
fi

# Link file(s)
ln -s ~/.vim/.vimrc ~/.vimrc
echo "NOTICE: Updated and linked vimrc"

prompt "NOTICE: There are vim plugins that can be installed" && vim +PlugInstall 
