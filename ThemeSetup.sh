#!/usr/bin/env sh
# Remove existing themes efficiently
themes_to_remove=(
    "catppuccin-latte"
    "flexoki-light" 
    "rose-pine"
    "hackerman"
    "ristretto"
    "kanagawa"
#   "nord"
#   "gruvbox"
#   "everforest"
#   "catppuccin"
#   "ethereal"
)

for theme in "${themes_to_remove[@]}"; do
    rm -rf "$HOME/.local/share/omarchy/themes/$theme/"
    rm -f "$HOME/.config/omarchy/themes/$theme"
done

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

# Theme Tweaks
\rm -f "$HOME/.config/omarchy/themes/tokyoled/backgrounds/black.jpg"
cp "$HOME/.config/omarchy/themes/ethereal/backgrounds/1.jpg" "$HOME/.config/omarchy/themes/tokyoled/backgrounds/1.jpg"
\rm -rf "$HOME/.config/omarchy/themes/neo-sploosh/backgrounds/"
mkdir "$HOME/.config/omarchy/themes/neo-sploosh/backgrounds/"
cp "$HOME/.config/omarchy/themes/ethereal/backgrounds/1.jpg" "$HOME/.config/omarchy/themes/neo-sploosh/backgrounds/1.jpg"
\cp "$HOME/.config/omarchy/themes/tokyo-night/neovim.lua" "$HOME/.config/omarchy/themes/tokyoled/neovim.lua"
