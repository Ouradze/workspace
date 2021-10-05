#!/usr/bin/env bash

# specific setup
misceallenous() {
    # codec video
    echo "Misceallenous dependencies, video codec, exfat, ..."
    sudo apt install libavcodec-extra
    # exfat 
    sudo apt-get install exfat-fuse exfat-utils
}

git_configuration() {
    # use system configuration and add local one
    echo "Adding gitconfig..."
    rm -rf ~/.gitconfig \
    && ln -s $(pwd)/gitconfig ~/.gitconfig
}

dependencies() {
    echo "Setting up system dependencies..."
    sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
        bat zsh git-cola ripgrep htop cargo yakuake silversearcher-ag ripgrep
    sudo apt install python3-dev postgresql postgresql-contrib python3-psycopg2 libpq-dev

    
    # install black for python project
    pip3 install --user black
    # Docker
    # add docker gpg key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge test"
    # gitk
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io gitk
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
}

node_setup() {
    echo "Settings up node"
    mkdir ~/.nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    nvm install 12.4
    # diff so fancy
    npm install -g diff-so-fancy
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    # avoid node install as we ue nvm
    sudo apt update && sudo apt install --no-install-recommends yarn
}

devops() {
    echo "Setting up Kubctl"
    rm -rf /user/local/bin/kubectl
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version

    echo "Setting up k3d"
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

    echo "Setting up Helm"
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt-get install apt-transport-https --yes
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm

    echo "Setting up docker compose"
    sudo rm /usr/local/bin/docker-compose
    pip3 uninstall docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
}

install_oh_my_zsh() {
    echo "Setting up zsh..." \
    && rm -rf ~/.zshrc ~/.oh-my-zsh \
    && ln -s $(pwd)/zshrc ~/.zshrc \
    && git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && chsh -s /bin/zsh \
    && git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k \
    && mkdir -p ~/.oh-my-zsh/custom/themes
    cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/unixorn/fzf-zsh-plugin.git fzf-zsh-plugin
}

dev_tools() {
    echo "Setting up dev tools..."
    # Neovim use only apt install when 0.5 is released
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install neovim

    # Zoxide
    curl -sS https://webinstall.dev/zoxide | bash

    # procs
    sudo snap install procs

    # gping
    echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
    wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
    sudo apt update
    sudo apt install gping

    # jq
    sudo apt-get install jq

    # LunarVim
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

    # install poetry package manager
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python*
    
    cargo install sd lsd exa choose du-dust git-delta
}

python_setup() {
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
}

kde() {
  kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta ""
  qdbus org.kde.KWin /KWin reconfigure
}

#dependencies
#install_oh_my_zsh
#node_setup
git_configuration
