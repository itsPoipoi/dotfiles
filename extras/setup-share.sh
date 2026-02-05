#!/bin/bash
# Direct Ethernet setup for fast file transfers

# Assign Ethernet interface var
if ip addr show | rg "eno1" &>/dev/null; then
  ETH_IF="eno1"
elif ip addr show | rg "eth0" &>/dev/null; then
  ETH_IF="eth0"
elif ip addr show | rg "enp0" &>/dev/null; then
  ETH_IF="enp0s13f0u1"
fi

# Assign static IPs based on machine role
# Set ROLE=laptop on laptop, ROLE=desktop on desktop
ROLE="$1"

if [[ -z "$ROLE" ]]; then
  echo "Usage: $0 <laptop|desktop>"
  exit 1
fi

if [[ "$ROLE" == "laptop" ]]; then
  IP="192.168.50.1/24"
elif [[ "$ROLE" == "desktop" ]]; then
  IP="192.168.50.2/24"
else
  echo "Invalid role: $ROLE"
  exit 1
fi

echo "Setting IP $IP on interface $ETH_IF..."
sudo ip addr flush dev "$ETH_IF"
sudo ip addr add $IP dev "$ETH_IF"
sudo ip link set "$ETH_IF" up

echo "Testing connectivity..."
if [[ "$ROLE" == "laptop" ]]; then
  ping -c 3 192.168.50.2
else
  ping -c 3 192.168.50.1
fi

echo "Direct Ethernet setup complete!"
echo "You can now use rsync or scp to transfer files between machines."
