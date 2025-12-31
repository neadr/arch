# Arch post install <div align="center">

<div align="center">
  <h3> Fear is only as deep as the mind allows </h3>
  <h2 align="center"> ━━━━━━━ ━━━━━ ❖ ━━━━━━━ ━━━━━ </h2>
</div>

## Table of contents 

- [AUR helper](#aur-helper)
- [What's in this repo](#whats-in-this-repo)
- [Dependencies](#dependencies)
- [Installation](#installation)
  
## AUR Helper 
Once I finish a minimal Arch Linux installation and reach the TTY, my first step is to install an AUR helper. This makes it much easier to manage packages that are not included in the official Arch repositories.
My usual choices are `paru` or `yay`.

**[paru](https://github.com/Morganamilo/paru)** 
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

**[yay](https://github.com/Jguer/yay)** 
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

## What’s in this repo
This is the structure of the config files.
-  **`.config/`**
    - kitty
    - hypr
    - nvim
    - swaylock
    - waybar  
-  **`.wallpapers/`** - The wallpaper folder, swaybg is config to point here.
-   `.bashrc` - Bash shell config
-   `.zshrc` - Zsh shell config

## Dependencies
In order to install dependecies `sudo pacman -S`

<table>
<tr>
<td valign="top">

### Core & System
* hyprland
* hypridle
* mate-polkit
* networkmanager
* bluez, blueman

</td>
<td valign="top">

### Details
* hyperland tilling manager
* hyprland idle 
* polkit manager
* Network (nmtui)
* bluetooth  

</td>
</tr>
</table>

<table>
<tr>
<td valign="top">

### APPs & Theming 
* swaybg
* swalock
* kitty
* waybar
* rofi
* ranger
* thunar
* neovim
* pavucontrol
* pamixer
* xarchiver
* zip unrar unzip
* udiskie ntfs-3g
* gilb2
* gvfs
* nwg-look
* eza
* nerd-fonts
* firefox

</td>
<td valign="top">

### Details
* CLI for setting wallpapers
* CLI locking 
* Terminal emulator
* Bar  
* Menu
* Terminal file manager
* GUI file manager
* Editor
* pulseaudio GUI
* pulseaudio CLI
* archiver GUI
* extract tools
* automounter NTFS read & write
* Trash
* Trash GUI
* GUI for changing themes
* ls color command
* Nerd fonts
* Firefox Browser   

</td>
</tr>
</table>

## Installation
Network manager it needs to be enabled and running 
```sh
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager 
```

In a minimal Arch Linux environment, the standard user directory structure is not created automatically.
This can be resolved by installing xdg-user-dirs and updating the directory configuration:
```sh
sudo pacman -S xdg-user-dirs

xdg-user-dirs-update
```
Change directory to Dowloads 
```sh
cd Downloads 
```
clone config files 
```sh
git clone https://gitlab.com/neadr/dott.git
```
Copy dott config to system 
```sh
cp dott/.config $HOME/
cp .wallpapers $HOME/
cp .bashrc $HOME/
cp .zshrc $HOME/
```
