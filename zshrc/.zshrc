# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
    bindkey '^[[Z' autosuggest-accept # shift-tab
    bindkey -M vicmd -s '^F' '\nzi\n'
    bindkey -M viins -s '^F' 'zi\n'
    bindkey -M vicmd -s '^Y' '\ny\n'
    bindkey -M viins -s '^Y' 'y\n'
    bindkey -M viins "^W" forward-word
    bindkey -M viins "^B" backward-kill-word
    bindkey -M viins "\e[1;5C" forward-word
    bindkey -M viins "\e[1;5D" backward-word
    bindkey -M viins "\e[3;5~" kill-word
}
# Load keybinds after zvm keybinds
zvm_after_init_commands+=(lazykeys)

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Editor's
export EDITOR=nvim
export VISUAL=nvim

# fzf exports
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_ALT_C_COMMAND="fd --hidden --follow --type d"
export FZF_CTRL_T_COMMAND="fd --hidden --follow --type f"

export FZF_DEFAULT_OPTS='--style=default --info=inline --cycle --layout=reverse --height=90% --preview-window=wrap --marker="*"'
export FZF_CTRL_R_OPTS="--prompt='CMD-Hist > ' --preview 'echo {}' --preview-window down:3:wrap"
export FZF_ALT_C_OPTS="
  --prompt='CWD-Dir > '
  --walker-skip .git,node_modules,target
  --preview 'eza -aTL 2 --group-directories-first --color=always --icons=always {}'
