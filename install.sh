#!/usr/bin/env bash

# specific setup
misceallenous() {
    # codec video
    echo "Misceallenous dependencies, video codec, exfat, ..."
    sudo apt install libavcodec-extra
    # exfat 
    sudo apt-get install exfat-fuse exfat-utils
}

save_terminal_conf() {
    echo "Saving terminal configuration"
    rm -rf terminal_settings.txt
    dconf dump /org/gnome/terminal/ > terminal_settings.txt
}

# normal setup
load_terminal_settings() {
    echo "Loading terminal settings..."
    dconf reset -f /org/gnome/terminal/
    dconf load /org/gnome/terminal/ < terminal_settings.txt
}

git_configuration() {
    echo "Adding gitconfig..."
    rm -rf ~/.gitconfig \
    && ln -s $(pwd)/gitconfig ~/.gitconfig
}

font() {
    echo "Setting up fonts"
    rm -rf ~/.local/share/fonts
    mkdir -p ~/.local/share/fonts
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    cd fonts
    ./install.sh
    # clean-up a bit
    cd ..
    rm -rf fonts
    fc-cache -f -v
    # unizp and paste
    # https://github.com/ryanoasis/nerd-fonts/releases/tag/v2.0.0
}

dependencies() {
    echo "Setting up system dependencies..."
    sudo apt install tmux \
        powerline \
        fonts-powerline \
        curl \
        python3-pip \
        python-pip \
        virtualenvwrapper \
        gettext \
        htop \
        ripgrep \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        git-cola \
        filezilla \
        hub \
        postgresql-client-common \
        postgresql-client \
        libpq-dev \
        libcairo2-dev \
        libjpeg-dev \
        libpango1.0-dev \
        libgif-dev \
        build-essential \
        g++ \
        libjpeg-dev \
        libyaml-dev \
        libffi-dev \
        libxml2-dev \
        libxslt1-dev \
        libldap2-dev \
        libsasl2-dev \
        libzbar-dev \
        binutils \
        libproj-dev \
        gdal-bin \
        zsh \
        gnome-tweak-tool \
        bat
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
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    nvm install 12.4
    # diff so fancy
    npm install -g diff-so-fancy
}

devops() {
    echo "Settings up Kompose"
    rm -rf /user/local/kompose
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.18.0/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv ./kompose /usr/local/bin/kompose

    echo "Setting up Kubctl"
    rm -rf /user/local/bin/kubectl
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version

    echo "Setting up minikube"
    rm -rf /user/local/bin/minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
    sudo cp minikube /usr/local/bin && rm minikube

    echo "Setting up Helm"
    curl -LO https://git.io/get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh

    echo "Setting up docker compose"
    sudo rm /usr/local/bin/docker-compose
    pip3 uninstall docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
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
    && mkdir -p ~/.oh-my-zsh/custom/themes \
    && rm -rf ~/z.sh \
    && curl -fLo ~/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh \
    && pip3 install virtualenv virtualenvwrapper
}

setup_tmux() {
    echo "Setting up tmux..." \
    && rm -rf ~/.tmux.conf ~/.tmux \
    && ln -s $(pwd)/tmux.conf ~/.tmux.conf \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && ~/.tmux/plugins/tpm/bin/install_plugins
}

setup_neovim() {
    echo "Setting up neovim..." \
    && sudo apt-get install neovim \
    && rm -rf ~/.fzf ~/.config/nvim\
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install \
    && mkdir ~/.config/nvim \
    && ln -s $(pwd)/init.vim ~/.config/nvim/init.vim \
    && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && nvim +PlugInstall +qall 
}

dev_tools() {
    echo "Setting up dev tools..."
    # diff so fancy
    npm install -g diff-so-fancy
    # install poetry package manager
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

}

while getopts ":ht" opt; do
    case ${opt} in
        h )
            echo "h"
            ;;
        t )
            echo "t"
            ;;
        \? ) echo "usage: cmd [-h] [-t]"
    esac
done

echo -n "This will delete all your previous nvim, tmux and zsh settings. Proceed? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
  echo "Installing dependencies..." \
  && dependencies \
  && node_setup \
  && git_configuration \
  && install_oh_my_zsh \
  && setup_tmux \
  && devops \
  && setup_neovim \
  && dev_tools \
  && font \
  && load_terminal_settings \
  && misceallenous \
  && echo "Finished installation."
fi
