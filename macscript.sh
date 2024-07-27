#!/bin/bash

# Create backup folder
backup_folder="$HOME/.zdotbackup"
mkdir -p "$backup_folder"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not already installed
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# # Install oh my zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

install_brew_package() {
    local package_name="$1"
    local is_cask=false

    if [ "$1" = "--cask" ]; then
        is_cask=true
        package_name="$2"
    fi

    if $is_cask; then
        if ! brew list --cask "$package_name" &>/dev/null; then
            echo "Installing cask $package_name..."
            brew install --cask "$package_name"
        else
            echo "Cask $package_name is already installed."
        fi
    else
        if ! brew list "$package_name" &>/dev/null; then
            echo "Installing $package_name..."
            brew install "$package_name"
        else
            echo "$package_name is already installed."
        fi
    fi
}

install_brew_package --cask wezterm
install_brew_package --cask visual-studio-code
install_brew_package neovim
install_brew_package font-fira-code
install_brew_package sk
install_brew_package starship
install_brew_package zsh-autosuggestions
install_brew_package golang
install_brew_package node

copy_with_backup() {
    local source="$1"
    local dest="$2"
    if [ -e "$dest" ]; then
        echo "Backing up existing $dest..."
        mv "$dest/$source" "$backup_folder/$(basename "$source").$(date +%Y%m%d%H%M%S)"
    fi
    echo "Copying $source to $dest..."
    cp -l "$source" "$dest"
}

copy_with_backup .zprofile ~/
copy_with_backup .zshrc ~/
copy_with_backup .wezterm.lua ~/

if [ -d ~/.config ]; then
    echo "Backing up existing ~/.config..."
    mv ~/.config "$backup_folder/.config.$(date +%Y%m%d%H%M%S)"
fi
echo "Copying .config to ~/"
cp -r -l .config ~/

echo "Done. Please open wezterm as your new terminal."