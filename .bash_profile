test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    	start_agent;
    }
else
    start_agent;
fi

alias repos='cd ~/Documents/repos'
alias gs='git status'
alias cdl='cd $@ && ls'
alias reload='source ~/.bash_profile && source ~/.bashrc'

function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

function rename () { for i in $1*; do mv "$i" "${i/$1/$2}"; done; }

