# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Install deps & full upgrade
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel gcc make yazi ffmpeg 7zip jq poppler fzf zoxide eza tree-sitter-cli thunar nwg-displays resvg imagemagick git ripgrep fd unzip neovim trash-cli bat fastfetch stow man-db less zsh
omarchy-install-terminal kitty
sudo pacman -R --noconfirm omarchy-chromium alacritty ghostty 

# Change default shell to zsh
if [ ! "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
    echo "${YELLOW}Change default shell to zsh ?${NC} "
    echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:"
    read -n 1 -r user_input
    echo 
    case $user_input in
        [yY])
            echo "${GREEN}Making zsh the default shell."
            chsh -s $(which zsh)
            ;;
        *)
            echo "${GREEN}Bash remains the default shell."
            ;;
    esac
fi

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "${YELLOW}SSH key not found. Generate one now?${NC} "
    echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
    read -n 1 -r user_input
    echo 
    case $user_input in
        [yY])
           ssh-keygen -t rsa -b 4096 -C "poipoigit@gmail.com" 
            ;;
        *)
            echo "${GREEN}Run ${RED}sshkey ${GREEN}manually."
            ;;
    esac
fi

echo "${YELLOW}Set Git global config?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        git config --global pull.rebase false
        git config --global user.name "itsPoipoi"
        git config --global user.email "poipoigit@gmail.com"
        ;;
    *)
        echo "${GREEN}Run ${RED}gconf ${GREEN}manually."
        ;;
esac

# echo "${YELLOW}Set Ergol as x11 keymap (for sddm)?${NC} "
# echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
# read -n 1 -r user_input
# echo 
# case $user_input in
#     [yY])
#         sudo localectl set-x11-keymap fr pc105 ergol
#         ;;
#     *)
#         echo "${GREEN}Run ${RED}sxerg ${GREEN}manually."
#         ;;
# esac

echo "${YELLOW}Run Kanata install script?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        /bin/bash ~/dotfiles/kanata/.config/kanata/kanata-setup.sh
        ;;
    *)
        echo "${GREEN}Run ${RED}~/dotfiles/kanata/.config/kanata/kanata-setup.sh ${GREEN}manually."
        ;;
esac

echo "${YELLOW}Run stow install script and reload Hyprland if it's installed?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        cd ~/dotfiles/
        /bin/bash stow.sh
        cd
        ;;
    *)
        echo "${GREEN}Run ${RED}~/dotfiles/stow.sh ${GREEN}manually."
        ;;
esac

# Complete message
echo
echo "${GREEN}Setup complete! Profile reloading!${NC}"; sleep 2; clear; zsh
