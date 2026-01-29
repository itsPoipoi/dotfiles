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
    echo "Removing $theme"
    rm -rf "$HOME/.local/share/omarchy/themes/$theme/"
    rm -f "$HOME/.config/omarchy/themes/$theme"
done

# Install new
theme_install() {
  REPO_URL="$1"
  THEMES_DIR="$HOME/.config/omarchy/themes"
  THEME_NAME=$(basename "$REPO_URL" .git | sed -E 's/^omarchy-//; s/-theme$//')
  THEME_PATH="$THEMES_DIR/$THEME_NAME"

  # Remove existing theme if present
  if [ -d "$THEME_PATH" ]; then
    rm -rf "$THEME_PATH"
  fi

  # Silent cloner
  clone_theme() {
    echo "Installing $THEME_NAME"
    git clone "$REPO_URL" "$THEME_PATH" 2>/dev/null
  }

  # Clone the repo directly to ~/.config/omarchy/themes
  if ! clone_theme; then
    echo "Error: Failed to clone $THEME_NAME theme repo."
    exit 1
  fi
}

theme_install https://github.com/tahfizhabib/omarchy-amberbyte-theme
theme_install https://github.com/bjarneo/omarchy-aura-theme
theme_install https://github.com/Luquatic/omarchy-catppuccin-dark
theme_install https://github.com/ShehabShaef/omarchy-drac-theme
theme_install https://github.com/catlee/omarchy-dracula-theme
theme_install https://github.com/euandeas/omarchy-flexoki-dark-theme.git
theme_install https://github.com/bjarneo/omarchy-futurism-theme
theme_install https://github.com/tahayvr/omarchy-gold-rush-theme
theme_install https://github.com/bjarneo/omarchy-monokai-theme
theme_install https://github.com/monoooki/omarchy-neo-sploosh-theme
theme_install https://github.com/bjarneo/omarchy-pulsar-theme
theme_install https://github.com/dotsilva/omarchy-purplewave-theme
theme_install https://github.com/guilhermetk/omarchy-rose-pine-dark
theme_install https://github.com/Justin-De-Sio/omarchy-tokyoled-theme
theme_install https://github.com/tahayvr/omarchy-vhs80-theme

# Theme Tweaks
echo "Applying theme tweaks"
# Remove all themes btop bg
sed -i 's/t.\+main_bg.\+$/theme[main_bg]=""/' "$HOME"/.config/omarchy/themes/*/btop.theme
# Tokyoled: Replace backgrounds, tweak colors
\rm -f "$HOME/.config/omarchy/themes/tokyoled/backgrounds/black.jpg"
\cp "$HOME/.config/omarchy/themes/ethereal/backgrounds/1.jpg" "$HOME/.config/omarchy/themes/tokyoled/backgrounds/1.jpg"
sed -i 's/7aa2f7/5b8ffc/g' "$HOME/.config/omarchy/themes/tokyoled/colors.toml"
sed -i 's/787c99/e8e8e8/g' "$HOME/.config/omarchy/themes/tokyoled/colors.toml"
# Create Tokyoled variant with transparent waybar
\cp -rf "$HOME/.config/omarchy/themes/tokyoled" "$HOME/.config/omarchy/themes/tokyoled-2"
\cp "$HOME/.config/omarchy/themes/neo-sploosh/waybar.css" "$HOME/.config/omarchy/themes/tokyoled-2/"
echo "Theme setup complete"
