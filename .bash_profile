#! /bin/bash

# This tells shellcheck that this file is located in the home directory
# See: https://github.com/koalaman/shellcheck/wiki/SC1090
# shellcheck source=~

test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

# If available, view current git branch in terminal
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

SSH_ENV="$HOME/.ssh/environment"

# Commented out in favor of the below commands
# I think this was the predecessor?
# SSH_ENV="$HOME/.ssh/environment"
#
# function start_agent {
#     echo "Initialising new SSH agent..."
#     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#     echo succeeded
#     chmod 600 "${SSH_ENV}"
#     . "${SSH_ENV}" > /dev/null
#     /usr/bin/ssh-add;
# }
#
# # Source SSH settings, if applicable
#
# if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#     	start_agent;
#     }
# else
#     start_agent;
# fi


# Used to automatically start the ssh-agent when a terminal loads
env=~/.ssh/agent.env

# Load ssh-agent environment variables
agent_load_env() {
    test -f "$env" && . "$env" >| /dev/null ;
}

# Actually start the ssh-agent
agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ;
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; then
    agent_start
fi

test -f "$HOME/.ssh/*_rsa" && ssh-add ~/.ssh/*_rsa
test -f "$HOME/.ssh/*_ed25519" && ssh-add ~/.ssh/*_ed25519

unset env

# Git stuff from @jsleeper; if it breaks call him
alias ga='git add'
alias gb='git branch'
alias gbd='git branch -D'
alias gcan='git commit --amend --no-edit'
alias gcl='git clean -ffxd'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff --ws-error-highlight=all'
alias gdc='git diff --ws-error-highlight=all --cached'
alias gdcp='git diff --patience --ws-error-highlight=all --cached'
alias gdp='git diff --patience --ws-error-highlight=all'
alias gf='git fetch --prune'
alias gfp='git fetch --prune && git pull --rebase --autostash'
alias glg='git log --oneline --graph --all --decorate'
alias gp='git push --set-upstream origin HEAD'
alias grh='git reset --hard @{u}'
alias gs='git status'

# General aliasses
alias repos='cd ~/Documents/repos'
alias reload='source ~/.bash_profile && source ~/.bashrc'

function cdl () { cd "$@" && ls; }
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function rename () { for i in $1*; do mv "$i" "${i/$1/$2}"; done; }

