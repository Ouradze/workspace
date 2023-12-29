install_packet_manager() {
    sudo pacman -S base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
}

install_system_dependencies() {
    yay -Sy neovim-git rancher-k3d-bin kubectl python-gdal syncthing-gtk dnsutils visual-studio-code-bin netplan tmux devspace-bin python-powerline-git bat tk docker snapd powerline-fonts-git python-pyopenssl libffi rxvt-unicode urxvt-perls wget nerd-fonts-dejavu-complete lefthook deezer git-cola steam  slack discord ripgrep exa fd terraform \
    && yay -Sy choose-rust-git zoxide-bin the_silver_searcher sd gping
    && pip install virtualenvwrapper black
    # && npm install gtop -g
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
	&& bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
}

install_oh_my_zsh() {
    echo "Setting up zsh..." \
    && ln -s $(pwd)/zshrc ~/.zshrc \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && rm -rf ~/.zshrc ~/.oh-my-zsh \
    && chsh -s /bin/zsh \
    && mkdir -p ~/.oh-my-zsh/custom/themes \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
    && git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
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
    curl -sSL https://install.python-poetry.org | python3 -

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

    echo "Setting up docker compose"
    sudo rm /usr/local/bin/docker-compose
    pip3 uninstall docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    echo "Installing ssh-ident"
    mkdir -p ~/bin; wget -O ~/bin/ssh goo.gl/MoJuKB; chmod 0755 ~/bin/ssh

    echo "Setting up krew"
    (
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e \
        's/aarch64$/arm64/')" &&
        curl -fsSLO \
        "https://github.com/kubernetes-sigs/\
        krew/releases/latest/download/krew.tar.gz" &&
        tar zxvf krew.tar.gz &&
        KREW=./krew-"${OS}_${ARCH}" &&
        "$KREW" install krew
    )

    kubectl krew update
    kubectl krew upgrade

    echo "Setting up kustomize"
    curl -s \
    "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/\
    master/hack/install_kustomize.sh" \
    | bash
    mkdir $HOME/.local/bin
    mv $HOME/kustomize $HOME/.local/bin/kustomize

    echo "Setting up kube score"
    kubectl krew install score

    git clone git@github.com:rupa/z.git ~/z
}

install_packet_manager
install_system_dependencies
git_configuration
setup_neovim
install_oh_my_zsh
node_setup
dev_tools
