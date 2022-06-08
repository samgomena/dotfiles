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

# Note: This will print something that looks like an error if no `rsa` or `ed25519` keys are found.
# It doesn't stop execution of this file, unless you `set -e`.
ssh-add ~/.ssh/*_rsa
# ssh-add ~/.ssh/*_ed25519

# Source credentials
source ~/.creds.d/.artifactory
source ~/.creds.d/.gh_token
source ~/.creds.d/.vsphere

unset env

# Git alias stuff
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
alias reload='exec "$SHELL"'
alias cleanjq="jq -R 'fromjson? | select(type == \"object\")'"

function cdl () { cd "$@" && ls; }
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function rename () { for i in $1*; do mv "$i" "${i/$1/$2}"; done; }
function rmia () { docker images | grep "$1" | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi "$1":{} }

# Add Visual Studio Code (code) to $PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Load the fuck
# Docs: https://github.com/nvbn/thefuck#installation
# Removed on 8/12/21 because `thefuck` depends on a custom python install which overrides pyenv installs
# eval $(thefuck --alias)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

# Created by `pipx` on 2021-04-20 17:21:48
export PATH="$PATH:/Users/sgomena/.local/bin"

# Set up kubectl alias and completions
alias k=kubectl
complete -F __start_kubectl k

# alias trim_path='$PATH=$(python -c "from os import environ; \":\".join(set(environ.get("PATH").split(\":\")))"'

alias cst=$(which container-structure-test)
