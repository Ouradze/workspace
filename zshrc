# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir_writable dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

plugins=(
    git
    common-aliases
    django
    git-extras
    jsontools
    pip
    python
    systemd
    node
    npm
    z
)
#virtualenvwrapper

source $ZSH/oh-my-zsh.sh

# Virtualenv folder
export WORKON_HOME=$HOME/dev/.virtualenv
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_SCRIPT=~/.local/bin/virtualenvwrapper.sh
source ~/.local/bin/virtualenvwrapper.sh

# export configuration for postgres
export PGUSER=postgres
export PGHOST=localhost
export PGPORT=5432

# Export configuration for qemu
export LIBVIRT_DEFAULT_URI="qemu:///system"

# Docker compose autocompletion
fpath=(~/.zsh/completion $fpath)

# Go path for compilation
export GOPATH=$HOME/golang

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.vimpkg/bin
export PATH="$PATH:/opt/yarn-[version]/bin"

# Alias
alias gitk='gitk --all HEAD &'
alias vi='nvim'
alias docker_stop_all='docker stop $(docker ps -a -q)'
alias k8='kubectl'
alias mkvenv='mkvirtualenv -p $(pyenv which python3)'
alias lock="convert ~/Pictures/wallhaven-kwd36d.jpg -resize $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/') RGB:- | i3lock -k --raw $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'):rgb --image /dev/stdin"
alias gbrm="gb -v | grep gone | sed 's/^+ /  /' | awk '{print $1}' | xargs git branch -D"
alias mkctl="microk8s kubectl"
#alias clean_volume="$(docker rm $(docker ps -aq) && docker volume rm $(docker volume ls --filter dangling=true -q))"
alias gcln="git remote prune origin && git branch -v | grep gone | sed 's/^+ /  /' | awk '{print $1}' | xargs git branch -D"

# NPM
export PATH="$HOME/.npm-packages/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/scripts:$PATH"

# repo
export PATH=~/bin:$PATH

#if [[ -r ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
#    source ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
#fi

DISABLE_AUTO_TITLE=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Zsh poetry completion
fpath+=~/.zfunc
export PATH="$HOME/.poetry/bin:$PATH"

. ~/z.sh

source <(helm completion zsh)
source <(kompose completion zsh)

export $(egrep -v '^#' ~/.tokens.ini | xargs)

export SSH_AUTH_SOCK="${HOME}/.cache/ssh/agent.sock"

#if [[ $(ps x 2> /dev/null | grep -v '<defunct>' | grep ssh-agent -c) -ne 2 ]]; then
    #[[ -e ${SSH_AUTH_SOCK} ]] && rm ${SSH_AUTH_SOCK} || true
    #mkdir -p $(dirname ${SSH_AUTH_SOCK})
    #ssh-agent -a $SSH_AUTH_SOCK > /dev/null
#fi

eval "$(pyenv init -)"
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
