# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'

paru -S --needed --noconfirm kanata-bin

# Setup input access
sudo groupdel uinput
sudo groupadd --system uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo touch /etc/udev/rules.d/99-input.rules
sudo chmod a+w /etc/udev/rules.d/99-input.rules
sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' >> /etc/udev/rules.d/99-input.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo modprobe uinput

# Import config
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/main/kanata/.config/kanata/config.kbd --create-dirs -o /etc/kanata/config.kbd
sudo chmod -R a+rx /etc/kanata

# Setup systemd daemon service
curl -sL https://raw.githubusercontent.com/itsPoipoi/dotfiles/refs/heads/main/kanata/.config/kanata/kanata.service --create-dirs -o ~/.config/systemd/user/kanata.service
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service

echo "${GREEN}Kanata setup complete. ${RED}A reboot is required for Kanata to start."
