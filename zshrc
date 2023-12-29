# Path to your oh-my-zsh installation.
# autoload -Uz compinit && compinit -i
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir_writable dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

plugins=(
    git
    common-aliases
    git-extras
    jsontools
    pip
    python
    systemd
    node
    npm
    fzf
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

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

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.vimpkg/bin"
export PATH="$PATH:/opt/yarn-[version]/bin:$HOME/.rustup/bin:$HOME/.cargo/bin"

# Alias
alias gitk='gitk --all HEAD &'
alias vi='nvim'
alias docker_stop_all='docker stop $(docker ps -a -q)'
alias mkvenv='mkvirtualenv -p $(pyenv which python3)'
alias gbrm="gb -v | grep gone | sed 's/^+ /  /' | awk '{print $1}' | xargs git branch -D"
#alias clean_volume=`$(docker rm $(docker ps -aq) && docker volume rm $(docker volume ls --filter dangling=true -q))`
alias gcln="git remote prune origin && git branch -v | grep gone | sed 's/^+ /  /' | awk '{print $1}' | xargs git branch -D"
alias k="kubectl"

# NPM
export PATH="$HOME/.npm-packages/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/scripts:$PATH"

# repo

DISABLE_AUTO_TITLE=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Zsh poetry completion
fpath+=~/.zfunc
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/bin:/opt/sbt/bin:$PATH"

source <(helm completion zsh)
source <(kompose completion zsh)
source <(k3d completion zsh)
source <(kubectl completion zsh)

# krew
export PATH="$HOME/.krew/bin:$PATH"
# kustomize
export PATH="$HOME/.local/bin:$PATH"

rlk () {
        git checkout --theirs poetry.lock
        git unstage poetry.lock
        git checkout -- poetry.lock
        poetry lock
}
eval "$(pyenv init --path)"
eval "$(zoxide init zsh)"

fpath=(~/.zsh/completion $fpath)

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# alias ls = "exa"
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/ouradze/.sdkman"
complete -F __start_kubectl k
[[ -s "/home/ouradze/.sdkman/bin/sdkman-init.sh" ]] && source "/home/ouradze/.sdkman/bin/sdkman-init.sh"
