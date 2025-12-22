# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Install deps & full upgrade
sudo pacman -Syu
sudo pacman -S --noconfirm --needed base-devel gcc make git ripgrep fd unzip neovim trash-cli bat fastfetch stow man-db less zsh

if [ ! -f /usr/bin/yay ]; then
    cd
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd
fi

yay -Syu

# Reload Hyprland
if [ -f /usr/bin/hyprctl ]; then
    yay -S --noconfirm hyprshade
fi

# Change default shell to zsh
if [ ! "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
    echo "${YELLOW}Change default shell to zsh ?${NC} "
    echo "${RED}(Y)es, (N)o:"
    read -n 1 -r user_input
    echo 
    case $user_input in
        [yY])
            echo "${GREEN}Making zsh the default shell."
            chsh -s $(which zsh)
            ;;
        [nN])
            echo "${GREEN}Bash remains the default shell."
            ;;
        *)
            echo "${RED}Invalid choice."
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
    echo "${RED}(Y)es, (N)o:${NC}"
    read -n 1 -r user_input
    echo 
    case $user_input in
        [yY])
           ssh-keygen -t rsa -b 4096 -C "poipoigit@gmail.com" 
            ;;
        [nN])
            echo "${GREEN}Run ${RED}sshkey ${GREEN}manually."
            ;;
        *)
            echo "${RED}Invalid choice."
            ;;
    esac
fi

echo "${YELLOW}Set Git global config?${NC} "
echo "${RED}(Y)es, (N)o:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        git config --global user.name "itsPoipoi"
        git config --global user.email "poipoigit@gmail.com"
        ;;
    [nN])
        echo "${GREEN}Run ${RED}gconf ${GREEN}manually."
        ;;
    *)
        echo "${RED}Invalid choice."
        ;;
esac

echo "${YELLOW}Set Ergol as x11 keymap (for sddm)?${NC} "
echo "${RED}(Y)es, (N)o:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        sudo localectl set-x11-keymap fr pc105 ergol
        ;;
    [nN])
        echo "${GREEN}Run ${RED}sxerg ${GREEN}manually."
        ;;
    *)
        echo "${RED}Invalid choice."
        ;;
esac

echo "${YELLOW}Run Kanata install script?${NC} "
echo "${RED}(Y)es, (N)o:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        /bin/bash ~/dotfiles/kanata/.config/kanata/kanata-setup.sh
        ;;
    [nN])
        echo "${GREEN}Run ${RED}~/dotfiles/kanata/.config/kanata/kanata-setup.sh ${GREEN}manually."
        ;;
    *)
        echo "${RED}Invalid choice."
        ;;
esac

echo "${YELLOW}Run stow install script and reload Hyprland if it's installed?${NC} "
echo "${RED}(Y)es, (N)o:${NC}"
read -n 1 -r user_input
echo 
case $user_input in
    [yY])
        cd ~/dotfiles/
        /bin/bash stow.sh
        cd
        ;;
    [nN])
        echo "${GREEN}Run ${RED}~/dotfiles/stow.sh ${GREEN}manually."
        ;;
    *)
        echo "${RED}Invalid choice."
        ;;
esac

# Complete message
sleep 1
echo
echo "${GREEN}Setup complete! Profile reloading!${NC}"; zsh
