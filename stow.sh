#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="fastfetch,fd,hypr,imv,kitty,lazygit,opencode,satty,thunar,yazi,xfce4,zshrc"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES="$HOME/dotfiles"
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -d "$DOTFILES" --restow --adopt $folder
    git -C "$DOTFILES" restore .
done
popd

# Reload Hyprland
if [ -f /usr/bin/hyprctl ]; then
  echo "stow hypr"
  stow -d "$DOTFILES" --restow --adopt hypr
  git -C "$DOTFILES" restore .
  hyprctl reload
fi
