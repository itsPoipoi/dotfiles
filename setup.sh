# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Install deps & full upgrade
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel gcc make git ripgrep fd unzip neovim trash-cli bat fastfetch stow man-db less zsh

if [ ! -f /usr/bin/yay ]; then
    cd
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd
fi

yay -Syu --noconfirm

# Install hyprshade
if [ -f /usr/bin/hyprctl ]; then
    yay -S --noconfirm hyprshade
fi

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

# Install Homebrew & dependencies
if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  echo "${YELLOW}Installing Homebrew...${NC}"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else echo "${YELLOW}Homebrew is already installed. Skipping.${NC}"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install fzf
if [ ! -f /home/linuxbrew/.linuxbrew/bin/fzf ]; then
  brew install -q fzf
  else echo "${GREEN}Fzf is already installed. Skipping.${NC}"
fi

# Install eza
if [ ! -f /home/linuxbrew/.linuxbrew/bin/eza ]; then
  brew install -q eza
  else echo "${YELLOW}Eza is already installed. Skipping.${NC}"
fi

# Install zoxide
if [ ! -f ~/.local/bin/zoxide ]; then
  /bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
  else echo "${GREEN}Zoxide is already installed. Skipping.${NC}"
fi

# Install treesitter
if [ ! -f /home/linuxbrew/.linuxbrew/bin/tree-sitter ]; then
  brew install -q tree-sitter-cli
  else echo "${YELLOW}Treesitter is already installed. Skipping.${NC}"
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
        git config pull.rebase false
        git config --global user.name "itsPoipoi"
        git config --global user.email "poipoigit@gmail.com"
        ;;
    *)
        echo "${GREEN}Run ${RED}gconf ${GREEN}manually."
        ;;
esac

echo "${YELLOW}Set Ergol as x11 keymap (for sddm)?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        sudo localectl set-x11-keymap fr pc105 ergol
        ;;
    *)
        echo "${GREEN}Run ${RED}sxerg ${GREEN}manually."
        ;;
esac

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
