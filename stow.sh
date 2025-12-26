#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="fastfetch,hypr,kanata,kitty,nvim,thunar,yazi,xfce4,zshrc"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -D $folder
    stow --adopt $folder
    git restore .
done
popd

# Reload Hyprland
if [ -f /usr/bin/hyprctl ]; then
    echo "stow hypr"
	stow -D hypr
	stow --adopt hypr
    git restore .
	hyprctl reload
fi
