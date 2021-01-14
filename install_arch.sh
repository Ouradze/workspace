install_packet_manager() {
    git clone https://aur.archlinux.org/yay.git
    cd yay
    sudo pacman -U https://archive.archlinux.org/packages/g/go/go-2:1.14.7-1-x86_64.pkg.tar.zst
    makepkg -si
}

install_system_dependencies() {
    yay -Sy neovim visual-studio-code-bin tmux python-powerline-git bat tk docker snapd powerline-fonts-git arandr python-pyopenssl libffi rxvt-unicode urxvt-perls wget i3lock-color-git nerd-fonts-dejavu-complete lefthook deezer git-cola steam \
    && pip install virtualenvwrapper black
}

git_configuration() {
    echo "Adding gitconfig..."
    rm -rf ~/.gitconfig \
    && ln -s $(pwd)/gitconfig ~/.gitconfig
}

awesome_configuration() {
    echo "Adding awesome configuration..."
    rm -rf ~/.config/awesome/rc.lua \
    rm -rf ~/.config/awesome/autorun.sh \
    && ln -s $(pwd)/rc.lua ~/.config/awesome/rc.lua \
    && ln -s $(pwd)/autorun.sh ~/.config/awesome/autorun.sh
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
    npm install -g diff-so-fancy yarn
}

dev_tools() {
    echo "Setting up dev tools..."
    export POETRY_VERSION=1.0.9
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

    echo "Setting up pyenv"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo "Setting up Helm"
    sudo snap install helm --classic
     
    echo "Settings up Kompose"
    rm -rf /user/local/kompose
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv ./kompose /usr/local/bin/kompose

    echo "Setting up docker groups"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    echo "Setting up microk8s"
    sudo snap install microk8s --classic --channel=1.19
    sudo groupadd microk8s
    sudo usermod -aG microk8s $USER
    microk8s enable helm3

    echo "Setting up docker compose"
    sudo rm /usr/local/bin/docker-compose
    pip3 uninstall docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    echo "Installing ssh-ident"
    mkdir -p ~/bin; wget -O ~/bin/ssh goo.gl/MoJuKB; chmod 0755 ~/bin/ssh

    echo "Setting up kubctl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}

#awesome_configuration
#install_system_dependencies
#setup_neovim
#git_configuration
#install_oh_my_zsh
#dev_tools
#node_setup

install
