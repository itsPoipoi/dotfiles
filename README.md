# My dotfiles and install scripts for Arch (BTW)

### Clone then run setup.sh
```sh
git clone --recurse-submodules https://github.com/itsPoipoi/dotfiles.git $HOME/dotfiles
```
</details>

<details><summary>SSH</summary>

```sh
git clone --recurse-submodules git@github.com:itsPoipoi/dotfiles.git $HOME/dotfiles
```
</details>

```sh
sh ~/dotfiles/setup.sh
```
</details>

### [My Neovim](https://github.com/itsPoipoi/neovim) (Included here)


```sh
cd ~/dotfiles/
git submodule update --init --recursive
```
</details>

<details><summary>Standalone</summary>

```sh
git clone https://github.com/itsPoipoi/neovim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```
</details>
