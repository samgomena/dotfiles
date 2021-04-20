# Dotfiles

## Installation

    git clone --branch master --single-branch git://github.com/samgomena/dotfiles.git

## Setup

    chmod +x setup_vim.sh
    ./setup.sh  

## Or, for the _bold_

    git clone --branch master --single-branch git://github.com/samgomena/dotfiles.git && chmod u+x setup.sh && ./setup.sh

Note: This currently only installs .vimrc, it does **_not_** touch `.bashrc` or `.bash_profile`.

## Known Issues

* While this currently _does not_ touch any shell settings, it does not currently support `zsh`.
