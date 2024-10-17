#!/bin/bash

dnf_packages=(
    antigen
    zsh
    neovim
    fira-code-fonts
    skopeo
    starship
    golang
    nodejs
    docker
    kubectl
    helm
    k9s
    rust
    terraform
    awscli
    ImageMagick
    htop
    jq
    php
    # composer
    mailx
    xdotool # No direct equivalent for k6, using xdotool as a placeholder
)

snap_packages=(
    # Example: vscode, which is available as a snap package
    # code
)

flatpak_packages=(
    # Example: Spotify, which is available as a flatpak package
    # com.spotify.Client
)

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

dnf_package_exists() {
    dnf list installed "$1" &>/dev/null || command_exists "$1"
}

install_packages() {
    echo "Updating dnf..."
    # sudo dnf update -y
    sudo dnf copr enable atim/starship -y
    sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:zsh-users:antigen/Fedora_Rawhide/shells:zsh-users:antigen.repo


    echo "Installing dnf packages..."
    for package in "${dnf_packages[@]}"; do
        if ! dnf_package_exists $package; then
            echo "Installing $package..."
            sudo dnf install -y "$package"
        else
            echo "$package is already installed."
        fi
    done

    echo "Installing snap packages..."
    for package in "${snap_packages[@]}"; do
        if ! command_exists $package; then
            echo "Installing $package..."
            sudo snap install "$package"
        else
            echo "$package is already installed."
        fi
    done

    echo "Installing flatpak packages..."
    for package in "${flatpak_packages[@]}"; do
        if ! flatpak list | grep -q "$package"; then
            echo "Installing $package..."
            flatpak install -y "$package"
        else
            echo "$package is already installed."
        fi
    done

    # Composer global require as an example of post-install command
    # composer global require laravel/installer
}

move_dotfiles() {
    backup_folder="$HOME/.dotbackup"
    mkdir -p "$backup_folder"

    copy_with_backup() {
        local source="$1"
        local dest="$2"
        # if [ -e "$dest/$source" ]; then
        #     echo "Backing up existing $dest$source..."
        #     mv "$dest$source" "$backup_folder/$(basename "$source").$(date +%Y%m%d%H%M%S)"
        # fi
        echo "Copying $source to $dest..."
        # Use cp without -l for cross-device copying
        cp -l "$source" "$dest"
    }

    copy_no_hardlink() {
        local source="$1"
        local dest="$2"
        # if [ -e "$dest/$source" ]; then
        #     echo "Backing up existing $dest$source..."
        #     mv "$dest$source" "$backup_folder/$(basename "$source").$(date +%Y%m%d%H%M%S)"
        # fi
        echo "Copying $source to $dest..."
        cp "$source" "$dest"
    }

    # Check if file exists before copying
    [ -e .zprofile-fedora ] && copy_with_backup .zprofile-fedora ~/.zprofile
    [ -e .zshrc-fedora ] && copy_with_backup .zshrc-fedora ~/.zshrc
    [ -e .wezterm.lua ] && copy_no_hardlink .wezterm.lua ~/winhome/

    # if [ -d ~/.config ]; then
    #     echo "Backing up existing ~/.config..."
    #     mv ~/.config "$backup_folder/.config.$(date +%Y%m%d%H%M%S)"
    # fi
    echo "Copying .config to ~/"
    # Use cp -r without -l for directories, especially across devices
    cp -lr .config ~/
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

echo "Done. Please consider your terminal and desktop environment for further customization."
echo "Please install https://github.com/tonsky/FiraCode/releases for Fira Code font."

chsh -s $(which zsh)