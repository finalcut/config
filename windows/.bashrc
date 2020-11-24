alias less='less -r'
# --show-control-chars: help showing Korean or accented characters
alias ls='ls -lsa --color'
alias ll='ls -l'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias push='git push'
alias pull='git pull'
alias got='git '
alias get='git '
alias cler='clear '
alias clar='clear '
alias cl='clear '
alias mca='cd /c/dev/projects/mccoe/'
alias api='cd /c/dev/projects/mccoe/api && code .'
alias ui='cd /c/dev/projects/mccoe/ui && code ui.code-workspace'
alias proxyon='proxy_on'
alias proxyoff='proxy_off'
alias cleanup='clean_local_git'
alias journal='code /c/dev/bills-big-brain'
#used by git to write commit messages.  Point this your vs code probably.
export PROXY_SERVER=http://proxy.whatdomain.com #update with the right proxy server


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

   export NO_PROXY="gitlab.autobox.local,localhost,127.0.0.1,$USERDNSDOMAIN"

   # Update git and npm to use the proxy
   git config --global http.proxy $HTTP_PROXY
   # for more info on this
   # see: https://gitlab.cloud-glass.com/mccoe/onboarding/wikis/Development/Git_Questions#ssl-certificate-problem-unable-to-get-local-issuer-certificate
   # you'll need to know where your certs are; but that wiki should help
   git config --system http.sslcainfo /bin/curl-ca-bundle.crt
   git config --global http.sslcainfo /bin/curl-ca-bundle.crt
   npm config set proxy $HTTP_PROXY
   npm config set https-proxy $HTTP_PROXY
   npm config set strict-ssl false
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

   npm config rm proxy
   npm config rm https-proxy

   env | grep -e _PROXY -e GIT_ | sort
   echo -e "\nProxy-related environment variables removed."
}


function clean_local_git(){
  git checkout master && git fetch -p && for branch in `git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'`; do git branch -D $branch; done && git checkout develop && git pull
}







# start up ssh agent and load my keys; if you don't have SSH keys you want to load; you can comment out/delete the rest of the lines in this file.
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

load_keys(){
    ssh-add ~/.ssh/id_finalcut_rsa
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
