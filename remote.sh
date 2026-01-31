#!/usr/bin/env bash

BLUE=$'\e[0;34m'
GREEN=$'\e[0;32m'
if [[ ! -d "$HOME/dotfiles" ]]; then
  echo "${BLUE}Cloning dotfiles repository...${GREEN}"
  git clone https://github.com/itsPoipoi/dotfiles.git "$HOME"/dotfiles
else
  echo "${BLUE}Updating dotfiles repository...${GREEN}"
  git -C "$HOME"/dotfiles pull
  sleep 1
fi
bash "$HOME"/dotfiles/setup.sh
