# Dotfiles for Omarchy

🖥️ Designed for Omarchy, featuring Hyprland WM, Kitty terminal, Neovim editor, and Zsh shell with an interactive installer.

## ✨ Features

- **🎯 Interactive Installer**: Menu-driven setup with full / selective install options
- **🔄 Backup & Restore**: Automatic config backups with easy restoration
- **🏠 Hyprland WM**: Tiling window manager with custom keybindings and animations
- **🐱 Kitty Terminal**: GPU-accelerated terminal with themes and plugins
- **📝 Neovim Editor**: Full IDE setup with LSP, treesitter, and custom plugins
- **🐚 Zsh Shell**: Powerline prompt with zinit plugin manager
- **🛠️ Developer Tools**: fastfetch, yazi, lazygit, and more productivity tools

## 🚀 Quick Start

### Installation

HTTPS:
```bash
git clone https://github.com/itsPoipoi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

SSH:
```bash
 git clone git@github.com:itsPoipoi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## 🎛️ Interactive Installer

The installer provides three main options:

### 1. Full Automated Install
Runs all components with intelligent skip logic for already-configured items.

### 2. Selective Install
Choose specific components to install using number/letter keys:
- `1-9`: Select modules 1-9
- `a-c`: Select modules 10-12 (WebApps, Themes, Stow)
- `q`: Return to main menu

### 3. Backup & Restore
- Create backups of current configurations
- Restore from previous backups
- Backups stored in `~/.dots-backup/`

### Backup Coverage
Automatically backs up:
- Neovim config (`~/.config/nvim/`)
- SSH keys
- Git configuration
- Hyprland, Kitty, and other symlinked configs

## 📦 Components

### Window Manager
- **Hyprland**: Tiling WM with custom keybindings, workspaces, and effects

### Terminal & Shell
- **Kitty**: Fast, GPU-accelerated terminal
- **Zsh**: Shell with zinit plugin manager

### Editor & Tools
- **Neovim**: Full IDE with LSP, debugging, and git integration
- **fastfetch**: System information display
- **yazi**: Terminal file manager
- **lazygit**: Terminal Git UI
- **Various CLI tools**: fzf, ripgrep, etc.

### Utilities
- **Thunar**: File manager with plugins

## ⚙️ Configuration

### File Structure
```
~/dotfiles/
├── hypr/          # Hyprland window manager
├── kitty/         # Terminal emulator
├── zshrc/         # Zsh configuration
├── fastfetch/     # System info tool
├── yazi/          # File manager
└── setup.sh       # Interactive installer
```
