#!/usr/bin/env bash

# Modern Interactive Installer for Dotfiles
# Color constants
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
BLUE=$'\e[0;34m'
NC=$'\e[0m'  # No Color

# Global variables
BACKUP_DIR="$HOME/.dots-backup"
MODULES=("system_deps" "shell_setup" "sddm_setup" "neovim_config" "ssh_keys" "git_config" "kanata_setup" "vesktop_setup" "spicetify_setup" "webapps_cleanup" "themes_setup" "stow_config")
MODULE_NAMES=("System Dependencies" "Shell Setup (zsh)" "SDDM Setup" "Neovim Config" "SSH Keys" "Git Config" "Kanata Setup" "Vesktop Setup" "Spicetify Setup" "WebApps Cleanup" "Themes Setup" "Stow Config")
SELECTED_MODULES=()

# Utility functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Dotfiles Installer${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
}

print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

confirm_action() {
    local prompt="$1"
    local default="${2:-n}"
    local response

    echo -e "${YELLOW}$prompt${NC}"
    if [[ "$default" == "y" ]]; then
        echo -e "${RED}Press ${GREEN}Y ${RED}to accept / ${GREEN}N ${RED}to decline [Y/n]:${NC}"
    else
        echo -e "${RED}Press ${GREEN}Y ${RED}to accept / ${GREEN}N ${RED}to decline [y/N]:${NC}"
    fi

    read -n 1 -r response
    echo

    case "$response" in
        [yY]) return 0 ;;
        [nN]) return 1 ;;
        "") [[ "$default" == "y" ]] && return 0 || return 1 ;;
        *) return 1 ;;
    esac
}

# Backup functions
create_backup_dir() {
    local timestamp
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_PATH="$BACKUP_DIR/$timestamp"
    mkdir -p "$BACKUP_PATH" || { print_error "Failed to create backup directory"; return 1; }
    echo "$BACKUP_PATH"
}

backup_files() {
    local module="$1"
    local backup_path="$2"
    local module_dir="$backup_path/$module"
    mkdir -p "$module_dir"

    case "$module" in
        "shell_setup")
            echo "$SHELL" > "$module_dir/current_shell.txt" 2>/dev/null
            ;;
        "sddm_setup")
            if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
                sudo cp /etc/sddm.conf.d/autologin.conf "$module_dir/" 2>/dev/null || true
            fi
            ;;
        "neovim_config")
            if [[ -d ~/.config/nvim ]]; then
                cp -r ~/.config/nvim "$module_dir/" 2>/dev/null || true
            fi
            ;;
        "ssh_keys")
            if [[ -f ~/.ssh/id_rsa ]]; then
                cp ~/.ssh/id_rsa* "$module_dir/" 2>/dev/null || true
            fi
            ;;
        "git_config")
            git config --global --list > "$module_dir/git_config.txt" 2>/dev/null || true
            ;;
        "stow_config")
            local configs=("fastfetch" "hypr" "kitty" "lazygit" "thunar" "yazi" "xfce4" "zshrc")
            for config in "${configs[@]}"; do
                if [[ -d ~/.config/$config ]]; then
                    cp -r ~/.config/$config "$module_dir/" 2>/dev/null || true
                fi
            done
            ;;
    esac
}

perform_backup() {
    local backup_path
    backup_path=$(create_backup_dir) || return 1

    echo -e "${YELLOW}Creating backup...${NC}"

    for module in "${MODULES[@]}"; do
        case "$module" in
            "shell_setup"|"sddm_setup"|"neovim_config"|"ssh_keys"|"git_config"|"stow_config")
                backup_files "$module" "$backup_path"
                ;;
        esac
    done

    print_success "Backup created at: $backup_path"
    return 0
}

# Restore functions
list_backups() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        print_error "No backups found."
        return 1
    fi

    local backups=()
    while IFS= read -r -d '' dir; do
        backups+=("$(basename "$dir")")
    done < <(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -zr)

    if [[ ${#backups[@]} -eq 0 ]]; then
        print_error "No backups found."
        return 1
    fi

    echo -e "${BLUE}Available backups:${NC}"
    for i in "${!backups[@]}"; do
        echo "$((i+1)). ${backups[$i]}"
    done

    echo "$(( ${#backups[@]} + 1 )). Cancel"
    echo

    local choice
    read -p "Select backup to restore from: " choice

    if [[ $choice -ge 1 && $choice -le ${#backups[@]} ]]; then
        echo "${backups[$((choice-1))]}"
        return 0
    else
        return 1
    fi
}

restore_backup() {
    local backup_name="$1"
    local backup_path="$BACKUP_DIR/$backup_name"

    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup not found: $backup_name"
        return 1
    fi

    echo -e "${YELLOW}Restoring from backup: $backup_name${NC}"

    # Restore logic for each module
    if [[ -f "$backup_path/shell_setup/current_shell.txt" ]]; then
        local saved_shell
        saved_shell=$(cat "$backup_path/shell_setup/current_shell.txt")
        if [[ "$saved_shell" != "$SHELL" ]]; then
            echo -e "${YELLOW}Note: Shell was $saved_shell, currently $SHELL. Manual change may be needed.${NC}"
        fi
    fi

    if [[ -f "$backup_path/sddm_setup/autologin.conf" ]]; then
        sudo cp "$backup_path/sddm_setup/autologin.conf" /etc/sddm.conf.d/ 2>/dev/null || true
    fi

    if [[ -d "$backup_path/neovim_config/nvim" ]]; then
        rm -rf ~/.config/nvim 2>/dev/null || true
        cp -r "$backup_path/neovim_config/nvim" ~/.config/ 2>/dev/null || true
    fi

    if [[ -f "$backup_path/ssh_keys/id_rsa" ]]; then
        cp "$backup_path/ssh_keys/id_rsa"* ~/.ssh/ 2>/dev/null || true
        chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
    fi

    if [[ -f "$backup_path/git_config/git_config.txt" ]]; then
        # Note: Git config restore would require parsing and re-applying
        echo -e "${YELLOW}Git config backup found. Manual restore may be needed.${NC}"
    fi

    if [[ -d "$backup_path/stow_config" ]]; then
        local configs=("fastfetch" "hypr" "kitty" "lazygit" "thunar" "yazi" "xfce4" "zshrc")
        for config in "${configs[@]}"; do
            if [[ -d "$backup_path/stow_config/$config" ]]; then
                rm -rf ~/.config/$config 2>/dev/null || true
                cp -r "$backup_path/stow_config/$config" ~/.config/ 2>/dev/null || true
            fi
        done
    fi

    print_success "Restore completed. You may need to restart services or reload configs."
}

# Module functions
install_system_deps() {
    echo -e "${YELLOW}Installing system dependencies...${NC}"

    mkdir -p "$HOME/.config/Thunar" || print_error "Failed to create Thunar config directory"
    mkdir -p "$HOME/.config/xfce4" || print_error "Failed to create xfce4 config directory"

    if ! yay -S --noconfirm --needed base-devel gcc make yazi ffmpeg 7zip jq poppler fzf tumbler zoxide glow grc eza tree-sitter-cli pandoc-cli nwg-displays resvg imagemagick git ripgrep fd unzip neovim trash-cli bat fastfetch stow man-db less zsh; then
        print_error "Failed to install base packages"
        return 1
    fi

    if ! omarchy-install-terminal kitty; then
        print_error "Failed to install kitty terminal"
        return 1
    fi

    if ! yay -S --noconfirm --needed ntfs-3g dosfstools xfsprogs f2fs-tools udftools; then
        print_error "Failed to install filesystem tools"
        return 1
    fi

    if ! yay -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin xarchiver; then
        print_error "Failed to install thunar and plugins"
        return 1
    fi

    yay -R --noconfirm nautilus 2>/dev/null || true
    yay -R --noconfirm typora 2>/dev/null || true
    yay -R --noconfirm 1password-cli 2>/dev/null || true
    yay -R --noconfirm 1password-beta 2>/dev/null || true
    yay -R --noconfirm fcitx5-qt 2>/dev/null || true
    yay -R --noconfirm fcitx5-gtk 2>/dev/null || true
    yay -R --noconfirm fcitx5 2>/dev/null || true

    print_success "System dependencies installed."
}

install_shell_setup() {
    if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        if confirm_action "Change default shell to zsh?"; then
            echo -e "${GREEN}Making zsh the default shell.${NC}"
            if ! chsh -s "$(which zsh)"; then
                print_error "Failed to change default shell. You may need to run this manually."
                return 1
            fi
        else
            echo -e "${GREEN}Keeping current shell: $SHELL${NC}"
        fi
    else
        echo -e "${GREEN}Zsh is already the default shell.${NC}"
    fi
}

install_sddm_setup() {
    if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
        if confirm_action "Setup SDDM?"; then
            yay -S --noconfirm --needed sddm
            sudo systemctl enable sddm
            sudo rm -f /etc/sddm.conf.d/autologin.conf
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
            rm -rf "$HOME/sddm-astronaut-theme/"

            # Ergol keymap
            if confirm_action "Set Ergol as X11 keymap for SDDM?"; then
                sudo localectl set-x11-keymap fr pc105 ergol
            fi
        else
            echo -e "${GREEN}Skipping SDDM setup.${NC}"
        fi
    else
        echo -e "${GREEN}SDDM already configured.${NC}"
    fi
}

install_neovim_config() {
    if [[ ! -f ~/.config/nvim/setupcheck ]]; then
        if confirm_action "Import Neovim config?"; then
            echo -e "${YELLOW}Installing Neovim config...${NC}"
            mv ~/.config/nvim{,.bak} 2>/dev/null || true
            if ! git clone https://github.com/itsPoipoi/neovim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim; then
                print_error "Failed to clone Neovim config repository"
                return 1
            fi
        else
            echo -e "${GREEN}Skipping Neovim config import.${NC}"
        fi
    else
        echo -e "${GREEN}Neovim config already imported.${NC}"
    fi
}

install_ssh_keys() {
    if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
        if confirm_action "Generate SSH key?"; then
            if ! ssh-keygen -t rsa -b 4096 -C 'poipoigit@gmail.com'; then
                print_error "Failed to generate SSH key"
                return 1
            fi
        else
            echo -e "${GREEN}Skipping SSH key generation.${NC}"
        fi
    else
        echo -e "${GREEN}SSH key already exists.${NC}"
    fi
}

install_git_config() {
    if confirm_action "Set Git global config?"; then
        echo -e "${YELLOW}Default config:${NC}"
        echo "  Name: itsPoipoi"
        echo "  Email: poipoigit@gmail.com"
        echo "  Pull rebase: false"

        if confirm_action "Use default Git config?" "y"; then
            git config --global pull.rebase false || print_error "Failed to set git pull.rebase"
            git config --global user.name 'itsPoipoi' || print_error "Failed to set git user.name"
            git config --global user.email 'poipoigit@gmail.com' || print_error "Failed to set git user.email"
        else
            read -p "Enter Git name: " git_name
            read -p "Enter Git email: " git_email
            if confirm_action "Enable pull rebase?"; then
                git config --global pull.rebase true || print_error "Failed to set git pull.rebase"
            else
                git config --global pull.rebase false || print_error "Failed to set git pull.rebase"
            fi
            [[ -n "$git_name" ]] && git config --global user.name "$git_name" || print_error "Failed to set git user.name"
            [[ -n "$git_email" ]] && git config --global user.email "$git_email" || print_error "Failed to set git user.email"
        fi
    else
        echo -e "${GREEN}Skipping Git config.${NC}"
    fi
}

install_kanata_setup() {
    if confirm_action "Run Kanata install script?"; then
        /bin/bash ~/dotfiles/kanata/kanata-setup.sh
    else
        echo -e "${GREEN}Skipping Kanata setup.${NC}"
    fi
}

install_vesktop_setup() {
    if [[ ! -f /usr/bin/vesktop ]]; then
        if confirm_action "Setup Discord (Vesktop)?"; then
            yay -S --needed --noconfirm vesktop-bin
            omarchy-webapp-remove Discord
        else
            echo -e "${GREEN}Skipping Vesktop setup.${NC}"
        fi
    else
        echo -e "${GREEN}Vesktop already installed.${NC}"
    fi
}

install_spicetify_setup() {
    if [[ ! -f "$HOME/.spicetify/spicetify" ]]; then
        if confirm_action "Setup Spicetify? (Spotify needs to be logged in first!)"; then
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R
            curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
            spicetify config spotify_path "/opt/spotify"
            spicetify config custom_apps new-releases
            spicetify config custom_apps lyrics-plus
            spicetify backup apply
            rm -f "$HOME/dotfiles/install.log"
        else
            echo -e "${GREEN}Skipping Spicetify setup.${NC}"
        fi
    else
        echo -e "${GREEN}Spicetify already set up.${NC}"
    fi
}

install_webapps_cleanup() {
    echo -e "${GREEN}Removing undesirable WebApps...${NC}"
    omarchy-webapp-remove Basecamp
    omarchy-webapp-remove Figma
    omarchy-webapp-remove Fizzy
    omarchy-webapp-remove GitHub
    omarchy-webapp-remove "Google Contacts"
    omarchy-webapp-remove "Google Photos"
    omarchy-webapp-remove "Google Maps"
    omarchy-webapp-remove HEY
    omarchy-webapp-remove X
    omarchy-webapp-remove YouTube
    omarchy-webapp-remove Zoom
    print_success "WebApps cleanup completed."
}

install_themes_setup() {
    if confirm_action "Setup Omarchy themes?"; then
        /bin/bash ~/dotfiles/ThemeSetup.sh
    else
        echo -e "${GREEN}Skipping themes setup.${NC}"
    fi
}

install_stow_config() {
    if confirm_action "Run stow install script and reload Hyprland?"; then
        cd ~/dotfiles/ || exit
        /bin/bash stow.sh
        cd || exit
    else
        echo -e "${GREEN}Skipping stow config.${NC}"
    fi
}

# Menu functions
show_main_menu() {
    clear
    print_header

    echo "Choose an option:"
    echo "1. Full Automated Install (all modules)"
    echo "2. Selective Install (choose modules)"
    echo "3. Backup/Restore"
    echo "4. Exit"
    echo

    local choice
    read -n 1 -s choice
    echo "$choice"

    case $choice in
        1) full_install ;;
        2) selective_install ;;
        3) backup_restore_menu ;;
        4) exit 0 ;;
        *) echo -e "${RED}Invalid choice. Please try again.${NC}"; sleep 2; show_main_menu ;;
    esac
}

full_install() {
    clear
    print_header

    echo -e "${YELLOW}Full Install will run applicable modules (skipping already configured ones):${NC}"

    # Check which modules are applicable and display all with proper numbering
    local applicable_modules=()
    local applicable_names=()

    for i in "${!MODULES[@]}"; do
        local skip_reason=""
        case "${MODULES[$i]}" in
            "shell_setup")
                [[ "$SHELL" == "/usr/bin/zsh" ]] && skip_reason="Zsh already default shell"
                ;;
            "sddm_setup")
                [[ ! -f /etc/sddm.conf.d/autologin.conf ]] && skip_reason="SDDM autologin not found"
                ;;
            "neovim_config")
                [[ -f ~/.config/nvim/setupcheck ]] && skip_reason="Neovim config already imported"
                ;;
            "ssh_keys")
                [[ -f ~/.ssh/id_rsa.pub ]] && skip_reason="SSH key already exists"
                ;;
            "git_config")
                [[ -n "$(git config --global user.name 2>/dev/null)" ]] && skip_reason="Git config already set"
                ;;
            "kanata_setup")
                systemctl --user is-active --quiet kanata.service 2>/dev/null && skip_reason="Kanata service already running"
                ;;
            "vesktop_setup")
                [[ -f /usr/bin/vesktop ]] && skip_reason="Vesktop already installed"
                ;;
            "spicetify_setup")
                [[ -f "$HOME/.spicetify/spicetify" ]] && skip_reason="Spicetify already set up"
                ;;
            "themes_setup")
                [[ -d ~/.config/omarchy/themes/tokyoled ]] && skip_reason="Omarchy themes already installed"
                ;;
            "webapps_cleanup")
                [[ -d ~/.config/omarchy/themes/tokyoled ]] && skip_reason="Webapps already cleaned up"
                ;;
        esac

        if [[ -z "$skip_reason" ]]; then
            applicable_modules+=("${MODULES[$i]}")
            applicable_names+=("${MODULE_NAMES[$i]}")
            echo -e "$((i+1)). ${MODULE_NAMES[$i]} ${GREEN}(will run)${NC}"
        else
            echo -e "$((i+1)). ${MODULE_NAMES[$i]} ${YELLOW}(skipped: $skip_reason)${NC}"
        fi
    done

    if [[ ${#applicable_modules[@]} -eq 0 ]]; then
        echo
        echo -e "${GREEN}All modules are already configured!${NC}"
        sleep 2
        show_main_menu
        return
    fi

    echo

    if confirm_action "Proceed with full install?"; then
        if confirm_action "Create backup before installing?"; then
            perform_backup || { echo -e "${RED}Backup failed. Aborting.${NC}"; sleep 2; show_main_menu; }
        fi

        for i in "${!applicable_modules[@]}"; do
            echo -e "${BLUE}Running: ${applicable_names[$i]}${NC}"
            "install_${applicable_modules[$i]}"
        done

        finish_install
    else
        show_main_menu
    fi
}

selective_install() {
    clear
    print_header

    echo -e "${YELLOW}Select modules to install (space to toggle, enter to proceed):${NC}"
    echo

    # Simple toggle menu
    local selected=()
    local module_status=()

    for i in "${!MODULE_NAMES[@]}"; do
        module_status[$i]="[ ]"
    done

    while true; do
        clear
        print_header
        echo -e "${YELLOW}Select modules to install (press number/letter to toggle, enter to proceed, 0/q to go back):${NC}"
        echo

        for i in "${!MODULE_NAMES[@]}"; do
            local display_num
            if [[ $i -lt 9 ]]; then
                display_num="$((i+1))"
            else
                case $i in
                    9) display_num="a" ;;
                    10) display_num="b" ;;
                    11) display_num="c" ;;
                esac
            fi
            echo "$display_num. ${module_status[$i]} ${MODULE_NAMES[$i]}"
        done
        echo
        echo -e "${GREEN}Selected: ${#selected[@]}${NC}"
        echo

        local key
        read -n 1 -s key

        if [[ $key == "" ]]; then
            break
        elif [[ $key == "0" || $key == "q" ]]; then
            show_main_menu
            return
        elif [[ $key =~ [1-9] || $key =~ [abc] ]]; then
            local index
            if [[ $key =~ [1-9] ]]; then
                index=$((key - 1))
            else
                case $key in
                    a) index=9 ;;
                    b) index=10 ;;
                    c) index=11 ;;
                esac
            fi
            if [[ $index -ge 0 && $index -lt ${#MODULE_NAMES[@]} ]]; then
                if [[ "${module_status[$index]}" == "[ ]" ]]; then
                    module_status[$index]="[X]"
                    selected+=("$index")
                else
                    module_status[$index]="[ ]"
                    selected=(${selected[@]/$index})
                fi
            fi
        fi
    done

    if [[ ${#selected[@]} -eq 0 ]]; then
        echo -e "${RED}No modules selected.${NC}"
        sleep 2
        show_main_menu
        return
    fi

    echo
    echo -e "${YELLOW}Selected modules:${NC}"
    for idx in "${selected[@]}"; do
        echo "- ${MODULE_NAMES[$idx]}"
    done
    echo

    if confirm_action "Proceed with selective install?"; then
        if confirm_action "Create backup before installing?"; then
            perform_backup || { echo -e "${RED}Backup failed. Aborting.${NC}"; sleep 2; show_main_menu; }
        fi

        for idx in "${selected[@]}"; do
            echo -e "${BLUE}Running: ${MODULE_NAMES[$idx]}${NC}"
            "install_${MODULES[$idx]}"
        done

        finish_install
    else
        show_main_menu
    fi
}

backup_restore_menu() {
    clear
    print_header

    echo "Backup/Restore Options:"
    echo "1. Create new backup"
    echo "2. Restore from backup"
    echo "3. Back to main menu"
    echo

    local choice
    read -n 1 -s choice
    echo "$choice"

    case $choice in
        1)
            if perform_backup; then
                echo -e "${GREEN}Backup completed successfully.${NC}"
            fi
            sleep 3
            show_main_menu
            ;;
        2)
            local backup_name
            backup_name=$(list_backups)
            if [[ $? -eq 0 ]]; then
                if confirm_action "Restore from backup: $backup_name?"; then
                    restore_backup "$backup_name"
                fi
            fi
            sleep 3
            show_main_menu
            ;;
        3|0|q)
            show_main_menu
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            sleep 2
            backup_restore_menu
            ;;
    esac
}

finish_install() {
    echo
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${YELLOW}You may need to reload your shell or restart services.${NC}"

    if confirm_action "Reload zsh now?" "y"; then
        sleep 1
        clear
        zsh
    else
        echo -e "${GREEN}Please run 'zsh' manually to apply changes.${NC}"
        exit 0
    fi
}

# Main execution
main() {
    # Ensure backup directory exists
    mkdir -p "$BACKUP_DIR"

    # Show main menu
    show_main_menu
}

main "$@"
