#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

brew_package_exists() {
    case $1 in
        visual-studio-code)
            package_command="code"
            ;;
        neovim)
            package_command="nvim"
            ;;
        *)
            package_command="$1"
            ;;
    esac

    brew list "$1" &>/dev/null || command -v "$package_command" >/dev/null 2>&1
}

application_exists() {
    if [ $# -eq 0 ]; then
        return 1
    fi

    app_name=$(echo "$1" | sed 's/[-_]/ /g')
    
    if mdfind "kMDItemKind == 'Application'" | grep -qi "${app_name}.app"; then
        return 0
    fi

    return 1
}

install_packages() {
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi

    install_brew_package() {
        local package_name="$1"
        local is_cask=false

        if [ "$1" = "--cask" ]; then
            is_cask=true
            package_name="$2"
        fi

        if $is_cask; then
            if ! brew_package_exists $package_name; then
                echo "Installing cask $package_name..."
                brew install --cask "$package_name"
            else
                echo "$package_name is already installed."
            fi
        else
            if ! brew_package_exists $package_name; then
                echo "Installing $package_name..."
                brew install "$package_name"
            else
                echo "$package_name is already installed."
            fi
        fi
    }

    install_brew_package antigen
    install_brew_package --cask wezterm
    install_brew_package --cask visual-studio-code
    install_brew_package neovim
    install_brew_package font-fira-code
    install_brew_package sk
    install_brew_package starship
    install_brew_package golang
    install_brew_package node
    install_brew_package docker
    install_brew_package kubectl
    install_brew_package helm
    install_brew_package k9s

    if ! (brew_package_exists burp-suite || brew_package_exists burp-suite-professional || application_exists burp-suite || application_exists burp-suite-professional); then
        echo "1. Burp Community Edition (Free)"
        echo "2. Burp Suite Professional (Paid)"
        read -p "Which Burp Suite would you like to install? (1/2): " burp_choice

        if [ "$burp_choice" = "1" ]; then
            install_brew_package --cask burp-suite
        elif [ "$burp_choice" = "2" ]; then
            install_brew_package --cask burp-suite-professional
        else
            echo "Invalid choice. Skipping Burp Suite installation."
        fi
    else
        echo "Burp Suite is already installed."
    fi
    

}

move_dotfiles() {
    backup_folder="$HOME/.zdotbackup"
    mkdir -p "$backup_folder"


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
}

echo "What would you like to do?"
echo "1. Install packages"
echo "2. Move dotfiles"
echo "3. Both (install packages and move dotfiles)"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        install_packages
        ;;
    2)
        move_dotfiles
        ;;
    3)
        install_packages
        move_dotfiles
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Done. Please open wezterm as your new terminal."