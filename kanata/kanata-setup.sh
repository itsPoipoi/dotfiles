# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'

yay -S --needed --noconfirm kanata-bin

# Setup input access
sudo groupdel uinput
sudo groupadd --system uinput
sudo usermod -aG input "$USER"
sudo usermod -aG uinput "$USER"
sudo touch /etc/udev/rules.d/99-input.rules
sudo chmod a+w /etc/udev/rules.d/99-input.rules
sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' >>/etc/udev/rules.d/99-input.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo modprobe uinput

# Import config
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/kanata.kbd --create-dirs -o /etc/kanata/kanata.kbd
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/defsrc_pc.kbd --create-dirs -o /etc/kanata/defsrc_pc.kbd
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/defsrc_pc_anglemod.kbd --create-dirs -o /etc/kanata/defsrc_pc_anglemod.kbd
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/deflayer_nav.kbd --create-dirs -o /etc/kanata/deflayer_nav.kbd
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/deflayer_nav_lt.kbd --create-dirs -o /etc/kanata/deflayer_nav_lt.kbd
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/deflayer_nav_lt_hrm.kbd --create-dirs -o /etc/kanata/deflayer_nav_lt_hrm.kbd
sudo chmod -R 755 /etc/kanata

# Setup systemd daemon service
curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/omarchy/kanata/kanata.service --create-dirs -o ~/.config/systemd/user/kanata.service
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service

echo "${GREEN}Kanata setup complete. ${RED}A reboot is required for Kanata to start."
