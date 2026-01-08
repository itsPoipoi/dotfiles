# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Path Exports
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.spicetify"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
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
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept' 'ctrl-w:accept'
zstyle ':fzf-tab:*' fzf-min-height 25
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zz:*' fzf-preview 'eza -aD1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zza:*' fzf-preview 'eza -a1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zze:*' fzf-preview 'eza -alh --group-directories-first --icons --color=always $realpath'

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
    bindkey '^[[Z' autosuggest-accept # shift-tab
    bindkey -M vicmd -s '^F' '\nzi\n'
    bindkey -M viins -s '^F' 'zi\n'
    bindkey -M vicmd -s '^Y' '\ny\n'
    bindkey -M viins -s '^Y' 'y\n'
    # bindkey -M vicmd '^L' ffclear
    # bindkey -M viins '^L' ffclear
    bindkey -M viins "^W" forward-word
    bindkey -M viins "^B" backward-kill-word
    bindkey -M viins "\e[1;5C" forward-word
    bindkey -M viins "\e[1;5D" backward-word
    bindkey -M viins "\e[3;5~" kill-word
}
# Load keybinds after zvm keybinds
zvm_after_init_commands+=(lazykeys)

# Fastfetch on clear
# function ffclear { clear; fastfetch; zle redisplay; }
# zle -N ffclear

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Editor's
export EDITOR=nvim
export VISUAL=nvim

# fzf exports
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS='--cycle --layout=default --height=90% --preview-window=wrap --marker="*"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:wrap"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --tree --level=3 --color=always {}'"

# # Fastfetch on Startup
# if [ -f /usr/bin/fastfetch ]; then
# 	fastfetch
# fi

# Extracts any archive(s) (if unp isn't installed)
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

# Alias's for archives
mktar() { tar -cvzf "${1%/}.tar.gz" "${1%/}"; }
alias zip="zip -r"

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

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Internal IP Lookup.
	if [ -e /sbin/ip ]; then
		echo -n "Internal IP: "
		/sbin/ip addr show wlan0 | rg "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: "
		/sbin/ifconfig wlan0 | rg "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

# SSH keygen
alias sshkey="ssh-keygen -t rsa -b 4096 -C 'poipoigit@gmail.com'"

# Quick git config
gitconfig() {
    git config --global pull.rebase false
	git config --global user.name 'itsPoipoi'
	git config --global user.email 'poipoigit@gmail.com'
	echo "${YELLOW}GitHub name & email are now set globally."
}
alias gconf="gitconfig"

# Fast git push
gpp() {
    git add .
    git commit -m "..."
    git push
}

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Automatically do an ls after each zoxide: Only directories
zz ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -aD --icons
	else
		__zoxide_z ~ && eza -aD --icons
	fi
}

# Automatically do an ls after each zoxide: All files
zza ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -a --icons
	else
		__zoxide_z ~ && eza -a --icons
	fi
}

# Automatically do an ls after each zoxide: All files as list
zze ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -alh --icons --group-directories-first
	else
		__zoxide_z ~ && eza -alh --icons --group-directories-first
	fi
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

# Search files in the current folder
alias f="fd . | rg "

# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='fd . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

# Alias's to modified commands
alias grep="rg"
alias find="fd"
alias cat="bat"
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias less='less -R'
alias vi='nvim'
alias curl="curl -#"

# Personal Alias's
alias sht="omarchy-cmd-shutdown"
alias rbt="omarchy-cmd-reboot"
alias ff="fastfetch"
alias zi="__zoxide_zi"
alias kssh="kitten ssh"
alias ezrc='nvim ~/.zshrc'
alias src="clear; source ~/.zshrc"
