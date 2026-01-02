#!/bin/bash

set -e # Exit on error

# Color for user output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "                               ";
echo "                               ";
echo "                               ";
echo "                      __       ";
echo ".-----.-----.---.-.--|  |.----.";
echo "|     |  -__|  _  |  _  ||   _|";
echo "|__|__|_____|___._|_____||__|  ";
echo "                               ";
echo -e "${GREEN}Starting Arch post install script ....${NC}"
echo -e "${YELLOW}This script will:${NC}"
echo " - Update the system"
echo " - Create XDG directories"
echo " - Install microcode, NetworkManager, utilities"
echo " - Install paru AUR helper"
echo
echo -e "${RED}WARNING: Run this script on a fresh Arch Linux installation!${NC}"
echo 
read -r -p "Do you want to continue? (y/N): " response
echo

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${GREEN}Starting Arch Linux post-install script...${NC}"
else
    echo -e "${RED}Script aborted by user.${NC}"
    exit 0
fi

# Full system update
echo -e "${GREEN}Updating system ....${NC}"

# Install CPU microcode (detect Intel or AMD)
echo -e "${YELLOW}Installing CPU microcode...${NC}"
if grep -q GenuineIntel /proc/cpuinfo; then
    sudo pacman -S --needed --noconfirm intel-ucode
elif grep -q AuthenticAMD /proc/cpuinfo; then
    sudo pacman -S --needed --noconfirm amd-ucode
else
    echo -e "${RED}Unknown CPU vendor, skipping microcode.${NC}"
fi

# Install NetworkManager (common choice)
echo -e "${YELLOW}Installing and enabling NetworkManager...${NC}"
sudo pacman -S --needed --noconfirm networkmanager
sudo systemctl enable --now NetworkManager

# Install base-devel (needed for AUR)
echo -e "${YELLOW}Installing base-devel...${NC}"
sudo pacman -S --needed --noconfirm base-devel git

# Install paru as AUR helper (safe defaults, written in Rust)
echo -e "${YELLOW}Installing paru AUR helper...${NC}"
if ! command -v paru &> /dev/null; then
    git clone https://aur.archlinux.org/paru.git ~/paru
    cd ~/paru
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/paru
fi

#Installing xdg-user-dirs
echo -e "${YELLOW}Installing xdg-user-dirs...${NC}"
sudo pacman -S --needed --noconfirm xdg-user-dirs

#Create standard XDG user directories (Desktop, Documents, Downloads, Music, Pictures, Videos)
echo -e "${YELLOW}Creating XDG user directories...${NC}"
xdg-user-dirs-update

#Basic packages
echo -e "${YELLOW}Installing basic packages ...${NC}"
sudo pacman -S --needed --noconfirm vim neovim xdg-user-dirs eza ranger pavucontrol pamixer xachiver udiskie ntfs-3g gilb2 gvfs nerd-fonts 

echo -e "${YELLOW}Installing common utilities (vim, curl, wget, htop, etc.)...${NC}"
sudo pacman -S --needed --noconfirm curl wget htop unzip zip unrar p7zip mate-polkit bluez blueman rsync

# Hyprland
echo -e "${YELLOW}Installing common Hyprland ...${NC}"
sudo pacman -S --needed --noconfirm hyprland hypridle nwg-look rofi waybar swaylock swaybg firefox 

# Basic utils
echo -e "${YELLOW}Installing basic utils ...${NC}"
sudo pacman -S --needed --noconfirm kitty btop papirus-icon-theme thunar thunar-volman vlc  cmatrix fastfetch npm luarocks

# Optional: Install and apply personal dotfiles from Git
echo
echo -e "${YELLOW}Do you want to clone and apply your personal dotfiles? (y/N)${NC}"
read -r -p "Continue? " response
echo

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}Cloning dotfiles into ~/Downloads...${NC}"

    # Your dotfiles repository
    DOTFILES_REPO="https://gitlab.com/neadr/dott.git"
    DOTFILES_DIR="$HOME/Downloads/dott"

    # Remove any existing clone to start fresh
    if [ -d "$DOTFILES_DIR" ]; then
        echo -e "${YELLOW}Removing previous dotfiles clone...${NC}"
        rm -rf "$DOTFILES_DIR"
    fi

    # Clone the repository
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"

    if [ ! -d "$DOTFILES_DIR" ]; then
        echo -e "${RED}Failed to clone dotfiles repository.${NC}"
        echo -e "${RED}Check your internet connection or if the repository URL is correct.${NC}"
    else
        echo -e "${GREEN}Dotfiles cloned successfully from https://gitlab.com/tiku/dott.git${NC}"

        # Backup existing .config if it exists
        if [ -d "$HOME/.config" ]; then
            BACKUP_DIR="$HOME/.config.backup_$(date +%Y%m%d_%H%M%S)"
            echo -e "${YELLOW}Backing up existing ~/.config to $BACKUP_DIR${NC}"
            mv "$HOME/.config" "$BACKUP_DIR"
        fi

        # Merge .config: overwrite duplicates, keep anything not in repo, handle hidden files
        if [ -d "$DOTFILES_DIR/.config" ]; then
            echo -e "${YELLOW}Merging .config from dotfiles (overwriting existing files, preserving extras)...${NC}"
            mkdir -p "$HOME/.config"
            rsync -a "$DOTFILES_DIR/.config/" "$HOME/.config/"
            echo -e "${GREEN}.config merged successfully!${NC}"
        else
            echo -e "${YELLOW}Warning: .config folder not found in repository (skipping).${NC}"
        fi

        # Copy .wallpapers to ~/.wallpapers
        if [ -d "$DOTFILES_DIR/.wallpapers" ]; then
            echo -e "${YELLOW}Copying wallpapers to ~/.wallpapers...${NC}"
            mkdir -p "$HOME/.wallpapers"
            cp -r "$DOTFILES_DIR/.wallpapers"/* "$HOME/.wallpapers/" 2>/dev/null || echo "No files in .wallpapers"
        else
            echo -e "${YELLOW}.wallpapers folder not found in repo (skipping).${NC}"
        fi

        # Copy .bashrc
        if [ -f "$DOTFILES_DIR/.bashrc" ]; then
            echo -e "${YELLOW}Copying .bashrc...${NC}"
            cp "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
        else
            echo -e "${YELLOW}.bashrc not found in repo (skipping).${NC}"
        fi

        # Copy .zshrc
        if [ -f "$DOTFILES_DIR/.zshrc" ]; then
            echo -e "${YELLOW}Copying .zshrc...${NC}"
            cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
        else
            echo -e "${YELLOW}.zshrc not found in repo (skipping).${NC}"
        fi

        echo -e "${GREEN}Your dotfiles have been applied successfully!${NC}"
        echo -e "${YELLOW}Tip: Run 'source ~/.bashrc' or open a new terminal to apply shell changes immediately.${NC}"
    fi
else
    echo -e "${YELLOW}Skipping dotfiles installation.${NC}"
fi


echo -e "${GREEN}Done!${NC}"

exit 0
