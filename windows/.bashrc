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
alias warp='cd /c/dev/docker/warpbox/app/warp && code .'
alias aemis='cd /c/dev/websites/aemis/site/aemis && code .'
alias cloud='cd /c/dev/projects/AemisCloud/Aemis/Aemis && code .'
alias gfh='git flow hotfix start'
alias proxyon='proxy_on'
alias proxyoff='proxy_off'
#used by git to write commit messages.  Point this your vs code probably.
export PROXY_SERVER=http://proxy.hud.gov


# configure proxy for git while on corporate network
# From https://gist.github.com/garystafford/8196920
function proxy_on(){
   # assumes $USERDOMAIN, $USERNAME, $USERDNSDOMAIN
   # are existing Windows system-level environment variables

   # assumes $PASSWORD, $PROXY_SERVER, $PROXY_PORT
   # are existing Windows current user-level environment variables (your user)

   # environment variables are UPPERCASE even in git bash
   export HTTP_PROXY="$PROXY_SERVER:8080"
   export HTTPS_PROXY="$PROXY_SERVER:8443"
   export FTP_PROXY="$PROXY_SERVER:8080"
   export SOCKS_PROXY="$PROXY_SERVER:5050"

   export NO_PROXY="localhost,127.0.0.1,$USERDNSDOMAIN"

   # Update git and npm to use the proxy
   git config --global http.proxy $HTTP_PROXY
   git config --system http.sslcainfo /bin/curl-ca-bundle.crt
   git config --global http.sslcainfo /bin/curl-ca-bundle.crt
   # npm config set proxy $HTTP_PROXY
   # npm config set https-proxy $HTTP_PROXY
   # npm config set strict-ssl false
   # npm config set registry "http://registry.npmjs.org/"

   # optional for debugging; gives you a ton of extra info.  to turn off unset GIT_CURL_VERBOSE
   # export GIT_CURL_VERBOSE=1

   # optional Self Signed SSL certs and
   # internal CA certificate in an corporate environment
   # export GIT_SSL_NO_VERIFY=1


   env | grep -e _PROXY -e GIT_ | sort
   # echo -e "\nProxy-related environment variables set."

   # clear
}

# Disable proxy settings
function proxy_off(){
   variables=( \
      "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "SOCKS_PROXY" \
      "NO_PROXY" "GIT_CURL_VERBOSE" "GIT_SSL_NO_VERIFY" \
   )

   for i in "${variables[@]}"
   do
      unset $i
   done

   git config --global --unset http.proxy
   git config --global --unset http.sslcainfo
   git config --system --unset http.sslcainfo


   env | grep -e _PROXY -e GIT_ | sort
   echo -e "\nProxy-related environment variables removed."
}










# start up ssh agent and load my keys
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

load_keys(){
    ssh-add ~/.ssh/id_rsa
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
auth_sock="$SSH_AUTH_SOCK"
auth_sock_len=${#auth_sock}


if [ ! $auth_sock_len ] || [ $agent_run_state = 2 ]; then
    agent_start
    load_keys
fi



unset env
# end start of ssh agent and key loading
