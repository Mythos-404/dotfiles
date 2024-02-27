# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    if (( ${+commands[curl]} )); then
        curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
            https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    else
        mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
            https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
    source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
# for key ('k') bindkey -M vicmd ${key} history-substring-search-up
# for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mythos_404/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

cli_init_cache() {
    local cli_cache_file="${HOME}/.cache/cli_init/${1}"
    [[ ! -f "${cli_cache_file}" ]] && "${@}" > "${cli_cache_file}"
    source "${cli_cache_file}"
}

# ============= App ================
cli_init() {
    cli_init_cache zoxide init zsh
    cli_init_cache mcfly init zsh
}

# ============= Path ===============
# custom bin
# export PATH="$HOME/.local/bin:$PATH"

# rust
export PATH="$PATH:$HOME/.cargo/bin"

# ruby
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"


# ============= Conf ===============
# lang
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_CTYPE=en_US.UTF-8

# editor
export EDITOR=nvim
export VISUAL=nvim
export LESSOPEN='|~/.lessfilter %s'

# autopair
export AUTOPAIR_INIT_INHIBIT=true

# zsh-vim-mode
export ZVM_VI_ESCAPE_BINDKEY='^['
export ZVM_VI_INSERT_ESCAPE_BINDKEY='jk'
export ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
export ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
zvm_vi_yank() {
    zvm_yank
    printf %s "${CUTBUFFER}" | wl-copy -n
    zvm_exit_visual_mode
}
_zvm_vi_put_after() {
    CUTBUFFER=$(wl-paste -n)
    zvm_vi_put_after
    zvm_highlight clear
}
_zvm_vi_put_before() {
    CUTBUFFER=$(wl-paste -n)
    zvm_vi_put_before
    zvm_highlight clear
}
zvm_after_lazy_keybindings() {
    zvm_define_widget _zvm_vi_put_after
    zvm_define_widget _zvm_vi_put_before

    zvm_bindkey vicmd 'p' _zvm_vi_put_after
    zvm_bindkey vicmd 'P' _zvm_vi_put_before
}

zvm_after_init_commands+=(cli_init autopair-init)

# fzf
zstyle ':completion:*' extra-verbose true
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' single-group prefix color header
zstyle ':fzf-tab:*' continuous-trigger 'ctrl-_'
zstyle ':fzf-tab:*' switch-group 'alt-,' 'alt-.'
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS='+s +m -x -e --preview-window=hidden'
export FZF_TMUX_HEIGHT=$((LINES - 15))
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# zoxide
export _ZO_FZF_OPTS="--exact --no-sort --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --border=sharp --height=95% --info=inline --layout=reverse --tabstop=1 --select-1 --preview='eza --icons --color-scale --group-directories-first {2..}' --preview-window=down,30%,sharp"

# rustup
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
export CARGO_UNSTABLE_SPARSE_REGISTRY=true

# mcfiy
export MCFLY_KEY_SCHEME=vim
export MCFLY_INTERFACE_VIEW=TOP
export MCFLY_PROMPT="❯"
export MCFLY_FUZZY=2
export MCFLY_RESULTS=50

# ============= Alias ==============
alias sudo='sudo'
alias vim='nvim'
alias rm='echo "别用 rm 了好吗";false'
alias mkdir='mkdir -p'
alias ip='ip -color'
alias cat='bat -p'
alias jctl='journalctl -p 3 -xb'
alias top='btm'

alias ls='eza --icons --color-scale --group-directories-first'
alias ll='ls -l --git'        # Long format, git status
alias l='ll -a'               # Long format, all files
alias lr='ll -T'              # Long format, recursive as a tree
alias lx='ll -sextension'     # Long format, sort by extension
alias lk='ll -ssize'          # Long format, largest file size last
alias lt='ll -smodified'      # Long format, newest modification time last
alias lc='ll -schanged'       # Long format, newest status change (ctime) last

alias tp='gtrash put'
alias tf='gtrash find'
alias te='gtrash find --rm'
alias tt='gtrash restore'
alias tg='gtrash restore-group'
alias ts='gtrash summary'

alias copy='wl-copy'
alias paste='wl-paste'

alias P='paru'
alias Y='yazi'
alias N='nvim'
alias lzg='lazygit'
alias pn='pnpm'
alias ps='procs'
alias btp='btop'

alias mpd_update='(cd ~/Music && mpc clear && mpc ls | mpc add && mpc update mpc listall)'
alias us_alas='(cd ~/.local/share/AzurLaneAutoScript && podman-compose up &> /dev/null &) &> /dev/null && echo "Alas Run!"'
