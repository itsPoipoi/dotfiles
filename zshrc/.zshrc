# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path Exports
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.spicetify"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load completions
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

# Add in zsh plugins
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light MichaelAquilina/zsh-you-should-use
zinit light fdellwing/zsh-bat
zinit light Freed-Wu/zsh-help
zinit light Freed-Wu/fzf-tab-source

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Zsh vim config
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
ZVM_VI_SURROUND_BINDKEY=s-prefix
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_VI_EDITOR=nvim

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt notify
setopt globdots

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' fzf-min-height 25
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept' 'ctrl-w:accept' 'ctrl-u:preview-half-page-up' 'ctrl-d:preview-half-page-down'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -aD1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -aD1 --group-directories-first --icons --color=always $realpath'

# Shell integrations
# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
    eval "$(fzf --zsh)"
    eval "$(zoxide init zsh)"
}
zvm_after_init_commands+=(zvm_after_init)

# Keybindings
set -o ignoreeof
set -o vi
function lazykeys {
  bindkey -M viins -s '^F' 'zi\n'
  bindkey -M vicmd -s '^F' '\nzi\n'
  bindkey -M viins -s '^Y' 'y\n'
  bindkey -M vicmd -s '^Y' '\ny\n'
  bindkey -M viins "^W" vi-forward-word
  bindkey -M vicmd "^W" vi-forward-word
  bindkey -M viins "^B" vi-backward-word
  bindkey -M vicmd "^B" vi-backward-word
  bindkey -M viins "^H" backward-kill-word # CTRL + Backspace
  bindkey -M vicmd "^H" backward-kill-word # CTRL + Backspace
  bindkey -M viins "\e[1;5D" vi-backward-word # CTRL + Left
  bindkey -M viins "\e[1;5C" vi-forward-word  # CTRL + Right
  bindkey -M viins "\e[3;5~" kill-word # CTRL + Delete
}
# Load keybinds after zvm keybinds
zvm_after_init_commands+=(lazykeys)

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Editor's
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR="$EDITOR"

# fzf exports
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS_FILE="$HOME/.fzfopts"
export FZF_ALT_C_COMMAND="fd --hidden --follow --type d"
export FZF_ALT_C_OPTS="--prompt='CWD-Dir > ' "
export FZF_CTRL_T_COMMAND="fd --hidden --follow --type f"
export FZF_CTRL_T_OPTS="--multi --prompt='CWD-File > ' "
export FZF_CTRL_R_OPTS="--prompt='CMD-Hist > ' --preview 'echo {}' --preview-window down:3:wrap"

# Archives
alias zip="zip -r"
alias compress="mktar"
mktar() { tar -cvzf "${1%/}.tar.gz" "${1%/}"; }
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -H causes filename to be printed
	# -n causes line number to be printed
	# add rg args as $2+
	# -. for hidden files
	# --max-depth 1 for non-recursive
	rg -iHn $2 $3 $4 $5 --color=always "$1" . | less -R
}

# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Mount MTP
function mtpmount () {
  # Use -u arg to unmount
  gio mount $(gio mount -li | rg 'mtp' | awk -F= '{print $2}') $1
}

# IP Address Lookup
function myip () {
  # Internal IP Lookup
  if ip addr show | rg "eno1" &>/dev/null; then
    echo "Internal IP ( LAN): $(/sbin/ip addr show eno1 | rg "inet " | awk -F: '{print $1}' | awk '{print $2}')"
  elif ip addr show | rg "eth0" &>/dev/null; then
    echo "Internal IP ( LAN): $(/sbin/ip addr show eth0 | rg "inet " | awk -F: '{print $1}' | awk '{print $2}')"
  fi
  if ip addr show | rg "wlan0" &>/dev/null; then
    echo "Internal IP (WLAN): $(/sbin/ip addr show wlan0 | rg "inet " | awk -F: '{print $1}' | awk '{print $2}')"
  fi

	# External IP Lookup
  echo "External IP (IPv4): $(curl -s4 ifconfig.co)"
  echo "External IP (IPv6): $(curl -s6 ifconfig.co)"
}

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	\rm -f -- "$tmp"
}

#######################################################
# GENERAL ALIAS'S
#######################################################

# Add an "alert" alias 
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Change directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's eza lists
alias ls='eza -a --icons --group-directories-first' 			# add colors, icons, group directories
alias lf='eza -af --icons'  									# files only
alias ld='eza -aD --icons'										# directories only
alias ll='eza -alh --icons --group-directories-first'			# long listing format
alias lfiles='eza -alhf --icons'   								# long format, files only
alias ldirs='eza -alhD --icons'   								# long format, directories only
alias lx='eza -alhfs extension --icons '   						# sort files by extension
alias lk='eza -alhrs size --icons --group-directories-first'		# sort by size
alias lc='eza -alhrs changed --icons --group-directories-first'	# sort by change time
alias lt='eza -alhrs created --icons --group-directories-first'	# sort by date

# Search running processes
alias p="ps aux | rg "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 5'
alias less='less -R'
alias curl='curl -#'
alias vi='nvim'
alias open='xdg-open'
alias rsync='rsync -avh --progress --partial'
alias sshfs='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user'

# General
alias sht="omarchy-cmd-shutdown"
alias rbt="omarchy-cmd-reboot"
alias ezrc='nvim ~/.zshrc'
alias src="clear; source ~/.zshrc"

# Utils
alias ff="fastfetch"
alias zi="__zoxide_zi"
alias sy="sudo -E yazi"
alias c="opencode"
alias d="docker"
alias zg="lazygit"
alias zd="lazydocker"
alias kssh="kitten ssh"

# Tailscale
alias ts="tailscale status"
alias {tup,ton}="sudo tailscale up"
alias {twn,toff}="sudo tailscale down"
alias texon="sudo tailscale up --reset --login-server=https://headscale.poipoi.ovh --ssh --exit-node=pi"
alias texoff="sudo tailscale up --reset --login-server=https://headscale.poipoi.ovh --ssh"
