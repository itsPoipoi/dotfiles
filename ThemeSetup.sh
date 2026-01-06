#!/usr/bin/env sh
# Remove existing
\rm -rf "$HOME/.local/share/omarchy/themes/catppuccin-latte/"
\rm -f "$HOME/.config/omarchy/themes/catppuccin-latte"
\rm -rf "$HOME/.local/share/omarchy/themes/flexoki-light/"
\rm -f "$HOME/.config/omarchy/themes/flexoki-light"
\rm -rf "$HOME/.local/share/omarchy/themes/rose-pine/"
\rm -f "$HOME/.config/omarchy/themes/rose-pine"
\rm -rf "$HOME/.local/share/omarchy/themes/hackerman/"
\rm -f "$HOME/.config/omarchy/themes/hackerman"
# \rm -rf "$HOME/.local/share/omarchy/themes/ristretto/"
# \rm -f "$HOME/.config/omarchy/themes/ristretto"
# \rm -rf "$HOME/.local/share/omarchy/themes/kanagawa/"
# \rm -f "$HOME/.config/omarchy/themes/kanagawa"
# +rm -rf "$HOME/.local/share/omarchy/themes/nord/"
# \rm -f "$HOME/.config/omarchy/themes/nord"
# \rm -rf "$HOME/.local/share/omarchy/themes/gruvbox/"
# \rm -f "$HOME/.config/omarchy/themes/gruvbox"
# \rm -rf "$HOME/.local/share/omarchy/themes/everforest/"
# \rm -f "$HOME/.config/omarchy/themes/everforest"
# \rm -rf "$HOME/.local/share/omarchy/themes/catppuccin/"
# \rm -f "$HOME/.config/omarchy/themes/catppuccin"
# \rm -rf "$HOME/.local/share/omarchy/themes/ethereal/"
# \rm -f "$HOME/.config/omarchy/themes/ethereal"

# Install new
omarchy-theme-install https://github.com/Justin-De-Sio/omarchy-tokyoled-theme
omarchy-theme-install https://github.com/Luquatic/omarchy-catppuccin-dark
omarchy-theme-install https://github.com/bjarneo/omarchy-aura-theme
omarchy-theme-install https://github.com/bjarneo/omarchy-futurism-theme
omarchy-theme-install https://github.com/bjarneo/omarchy-pulsar-theme
omarchy-theme-install https://github.com/catlee/omarchy-dracula-theme
omarchy-theme-install https://github.com/monoooki/omarchy-neo-sploosh-theme
omarchy-theme-install https://github.com/tahfizhabib/omarchy-amberbyte-theme
omarchy-theme-install https://github.com/ShehabShaef/omarchy-drac-theme
omarchy-theme-install https://github.com/euandeas/omarchy-flexoki-dark-theme.git
omarchy-theme-install https://github.com/tahayvr/omarchy-gold-rush-theme
omarchy-theme-install https://github.com/tahayvr/omarchy-vhs80-theme
omarchy-theme-install https://github.com/bjarneo/omarchy-monokai-theme
omarchy-theme-install https://github.com/dotsilva/omarchy-purplewave-theme
omarchy-theme-install https://github.com/guilhermetk/omarchy-rose-pine-dark
omarchy-theme-install https://github.com/TyRichards/omarchy-space-monkey-theme/
omarchy-theme-install https://github.com/motorsss/omarchy-solarizedosaka-theme

# BG Setter
rm -f "$HOME/.config/omarchy/themes/tokyoled/backgrounds/black.jpg"
cp "$HOME/Pictures/Wallpapers/24.jpg" "$HOME/.config/omarchy/themes/tokyoled/backgrounds/24.jpg"
cp "$HOME/Pictures/Wallpapers/65.jpg" "$HOME/.config/omarchy/themes/tokyoled/backgrounds/65.jpg"
