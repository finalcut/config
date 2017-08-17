PATH=$PATH:/c/dev/tools/apache-ant-1.8.4/bin/ant.bat

alias less='less -r'
# --show-control-chars: help showing Korean or accented characters
alias ls='ls -F --color'
alias ll='ls -l'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias got='git '
alias get='git '
alias cler='clear '
alias clar='clear '
alias cl='clear '
alias warp='cd /c/dev/websites/wcs_ten/site/warp && code .'
alias aemis='cd /c/dev/websites/aemis/site/aemis && code .'
#used by git to write commit messages.  Point this your vs code probably.

export EDITOR='"/c/Program\ Files\ (x86)/Microsoft\ VS\ Code/Code.exe"'

# start up ssh agent and load my keys
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

load_keys(){
    ssh-add ~/.ssh/id_sbcs_rsa
    ssh-add ~/.ssh/id_finalcut_rsa
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    load_keys
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    load_keys
fi

unset env
# end start of ssh agent and key loading
