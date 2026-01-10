# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Install deps & full upgrade
mkdir -p "$HOME/.config/Thunar"
mkdir -p "$HOME/.config/xfce4"
yay -S --noconfirm --needed base-devel gcc make yazi ffmpeg 7zip jq poppler fzf tumbler zoxide glow grc eza tree-sitter-cli pandoc-cli nwg-displays resvg imagemagick git ripgrep fd unzip neovim trash-cli bat fastfetch stow man-db less zsh
omarchy-install-terminal kitty
yay -S --noconfirm --needed ntfs-3g dosfstools xfsprogs f2fs-tools udftools
yay -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin xarchiver
yay -R --noconfirm nautilus 2>/dev/null
yay -R --noconfirm typora 2>/dev/null
yay -R --noconfirm 1password-cli 2>/dev/null
yay -R --noconfirm 1password-beta 2>/dev/null
yay -R --noconfirm fcitx5-qt 2>/dev/null
yay -R --noconfirm fcitx5-gtk 2>/dev/null
yay -R --noconfirm fcitx5 2>/dev/null

# Change default shell to zsh
if [ ! "$SHELL" = "/usr/bin/zsh" ]; then
  echo "${YELLOW}Change default shell to zsh ?${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    echo "${GREEN}Making zsh the default shell."
    chsh -s "$(which zsh)"
    ;;
  *)
    echo "${GREEN}Bash remains the default shell."
    ;;
  esac
fi

sxerg() {
  echo "${YELLOW}Set Ergol as x11 keymap (for sddm)?${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    sudo localectl set-x11-keymap fr pc105 ergol
    ;;
  *)
    echo "${GREEN}X11 keymap was not changed."
    ;;
  esac
}

# Install sddm
if [ -f /etc/sddm.conf.d/autologin.conf ]; then
  echo "${YELLOW}Setup sddm?${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    yay -S --noconfirm --needed sddm
    sudo systemctl enable sddm
    sudo rm -f /etc/sddm.conf.d/autologin.conf
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
    \rm -rf "$HOME/sddm-astronaut-theme/"
    sxerg
    ;;
  *)
    echo "${GREEN}Skipping sddm setup."
    ;;
  esac
fi

# Neovim
if [ ! -f ~/.config/nvim/setupcheck ]; then
  echo "${YELLOW}Import Neovim config?${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    echo "${YELLOW}Installing Neovim config...${NC} "
    mv ~/.config/nvim{,.bak}
    mv ~/.local/share/nvim{,.bak}
    mv ~/.local/state/nvim{,.bak}
    mv ~/.cache/nvim{,.bak}
    git clone https://github.com/itsPoipoi/neovim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
    ;;
  *)
    echo "${GREEN}Run ${RED}sshkey ${GREEN}manually."
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
    ssh-keygen -t rsa -b 4096 -C 'poipoigit@gmail.com'
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
  git config --global user.name 'itsPoipoi'
  git config --global user.email 'poipoigit@gmail.com'
  ;;
*)
  echo "${GREEN}Run ${RED}gconf ${GREEN}manually."
  ;;
esac

echo "${YELLOW}Run Kanata install script?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo
case $user_input in
[yY])
  /bin/bash ~/dotfiles/kanata/kanata-setup.sh
  ;;
*)
  echo "${GREEN}Run ${RED}~/dotfiles/kanata/kanata-setup.sh ${GREEN}manually."
  ;;
esac

if [ ! -f /usr/bin/vesktop ]; then
  echo "${YELLOW}Setup Discord (Vesktop)?${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    yay -S --needed --noconfirm vesktop-bin
    omarchy-webapp-remove Discord
    ;;
  *)
    echo "${GREEN}Install Discord manually."
    ;;
  esac
fi

if [ ! -f "$HOME/.spicetify/spicetify" ]; then
  echo "${YELLOW}Setup Spicetify? ${RED}(Spotify needs to be logged in once first!)${NC} "
  echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
  read -n 1 -r user_input
  echo
  case $user_input in
  [yY])
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    spicetify config spotify_path "/opt/spotify"
    spicetify config custom_apps new-releases
    spicetify config custom_apps lyrics-plus
    spicetify backup apply
    \rm -f "$HOME/dotfiles/install.log"
    ;;
  *)
    echo "${GREEN}Install Spicetify manually."
    ;;
  esac
fi

echo "${GREEN}Removing undesirable WebApps..."
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

echo "${YELLOW}Setup a selection of Omarchy themes?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo
case $user_input in
[yY])
  /bin/bash ~/dotfiles/ThemeSetup.sh
  ;;
*)
  echo "${GREEN}Run ${RED}~/dotfiles/ThemeSetup.sh ${GREEN}manually."
  ;;
esac

echo "${YELLOW}Run stow install script and reload Hyprland if it's installed?${NC} "
echo "${RED}Press ${GREEN}Y ${RED}to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
echo
case $user_input in
[yY])
  cd ~/dotfiles/ || exit
  /bin/bash stow.sh
  cd || exit
  ;;
*)
  echo "${GREEN}Run ${RED}~/dotfiles/stow.sh ${GREEN}manually."
  ;;
esac

# Complete message
echo
echo "${GREEN}Setup complete! Profile reloading!${NC}"
sleep 1
clear
zsh
