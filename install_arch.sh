install_system_dependencies() {
    yay -Sy neovim visual-studio-code-bin tmux python-powerline-git bat tk docker snapd powerline-fonts-git \
    && pip install virtualenvwrapper black
}

git_configuration() {
    echo "Adding gitconfig..."
    rm -rf ~/.gitconfig \
    && ln -s $(pwd)/gitconfig ~/.gitconfig
}

installed() {
    #git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo "Setting up Helm"
    curl -LO https://git.io/get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
     
    echo "Settings up Kompose"
    rm -rf /user/local/kompose
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.18.0/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv ./kompose /usr/local/bin/kompose

    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
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
    && rm -rf ~/.fzf ~/.config/nvim\
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install \
    && mkdir ~/.config/nvim \
    && ln -s $(pwd)/init.vim ~/.config/nvim/init.vim \
    && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && nvim +PlugInstall +qall 
}

install() {

    echo "Setting up docker compose"
    sudo rm /usr/local/bin/docker-compose
    pip3 uninstall docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
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

install_oh_my_zsh() {
    echo "Setting up zsh..." \
    && rm -rf ~/.zshrc ~/.oh-my-zsh \
    && ln -s $(pwd)/zshrc ~/.zshrc \
    && git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && chsh -s /bin/zsh \
    && git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k \
    && mkdir -p ~/.oh-my-zsh/custom/themes \
    && rm -rf ~/z.sh \
    && curl -fLo ~/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh
}

node_setup() {
    echo "Settings up node"
    mkdir ~/.nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
    nvm install 12.4
    # diff so fancy
    npm install -g diff-so-fancy yarn
}

dev_tools() {
    echo "Setting up dev tools..."
    # install poetry package manager
    export POETRY_VERSION=1.0.9
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

}

#install_oh_my_zsh
#install
#setup_neovim
#git_configuration
#node_setup
#dev_tools
