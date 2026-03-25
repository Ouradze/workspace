#!/bin/bash
# Author: Mehdi Raddadi
# Date: 12/03/2026
# Description:
# Install Script for osx

set -euo pipefail

DOTFILES="$(pwd)"

echo "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

# Ensure brew is in PATH for the remainder of the script (especially for Apple Silicon)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing Homebrew casks..."
brew install --cask \
    spotify \
    obsidian \
    antigravity \
    localsend \
    capcut \
    discord \
    visual-studio-code \
    orbstack \
    ghostty \
    raycast \
    bitwarden \
    font-hack-nerd-font \
    karabiner-elements \
    sf-symbols

echo "Installing Homebrew formulas..."
brew tap FelixKratz/formulae
brew tap asmvik/formulae
brew tap jackielii/tap

brew install \
    sketchybar \
    borders \
    yabai \
    skhd-zig \
    devspace \
    ripgrep \
    zoxide \
    fzf \
    the_silver_searcher \
    eza \
    git-cola \
    sublime-merge \
    bat \
    jq \
    starship \
    fd \
    zsh-autocomplete \
    neovim \
    gemini-cli \
    lua \
    switchaudio-osx \
    nowplaying-cli \
    diff-so-fancy

# Install Rustup
echo "Installing Rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install uv
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"

echo "Configuring sketchybar..."
mkdir -p "$HOME/.config/sketchybar/plugins"
cp "$(brew --prefix)/share/sketchybar/examples/sketchybarrc" "$HOME/.config/sketchybar/sketchybarrc"
cp -r "$(brew --prefix)/share/sketchybar/examples/plugins/" "$HOME/.config/sketchybar/plugins/"
brew services start sketchybar || true # Don't fail if already started

echo "Configuring Yabai..."
yabai --start-service || true # Don't fail if already started
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
ln -s -f "$DOTFILES/osx/yabairc" ~/.yabairc 
sudo nvram boot-args=-arm64e_preview_abi

echo "Installing zinit..."
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "Installing sketchybar-app-font..."
mkdir -p "$HOME/Library/Fonts"
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.23/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

echo "Symlinking zshrc..."
ln -s -f "$DOTFILES/osx/zshrc" ~/.zshrc

# Symlink Ghostty config
echo "Symlinking Ghostty config..."
mkdir -p "$HOME/.config/ghostty"
ln -s -f "$DOTFILES/osx/ghostty/config" "$HOME/.config/ghostty/config"

# Install astronvim
echo "Installing AstroNvim..."
# Make a backup of your current nvim config (if exists)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
# Clean neovim folders
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.bak
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim ~/.local/state/nvim.bak
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim ~/.cache/nvim.bak

# Clone the repository
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
# remove template's git connection to set up your own later
rm -rf ~/.config/nvim/.git

echo "Installing vite.plus..."
curl -fsSL https://vite.plus | bash

echo "Installing ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "Done!"
