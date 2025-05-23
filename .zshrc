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
setopt EXTENDED_HISTORY

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
# setopt CORRECT

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

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

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
# End of lines added by compinstall

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

cli_init_cache() {
    local cli_cache_file="${HOME}/.cache/cli_init/${1}"
    [[ ! -f "${cli_cache_file}" ]] && "${@}" > "${cli_cache_file}"
    source "${cli_cache_file}"
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User Config
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ============= App ================
cli_init() {
    cli_init_cache zoxide init zsh
    cli_init_cache mcfly init zsh
    cli_init_cache direnv hook zsh
}

# ============= Path ===============
# custom bin
export PATH="$HOME/.local/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# rust
export PATH="$PATH:$HOME/.cargo/bin"

# golang
export GOPATH="$HOME/.golang"
export PATH="$PATH:$HOME/.golang/bin"

# ruby
export GEM_HOME="$HOME/.local/share/gem/ruby/3.0.0"
export PATH="$PATH:$GEM_HOME/bin"

# haskell
export GHCUP_INSTALL_BASE_PREFIX="$HOME"
export PATH="$PATH:$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin"

# nim
export PATH="$PATH:$HOME/.nimble/bin"

# ============= Config =============
# lang
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_CTYPE=en_US.UTF-8

# editor
export EDITOR=nvim
export VISUAL=nvim
export LESSOPEN='|~/.lessfilter %s'
export MANPAGER='nvim +Man!'

# rustup
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
export CARGO_UNSTABLE_SPARSE_REGISTRY=true

# UV
export UV_DEFAULT_INDEX="https://mirrors.bfsu.edu.cn/pypi/web/simple"

# autopair
export AUTOPAIR_INIT_INHIBIT=true

# zsh-vim-mode
export ZVM_VI_ESCAPE_BINDKEY='^['
export ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
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

zvm_after_init_commands+=(cli_init autopair-init init_fzf_binds)

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf-tab
zstyle ':completion:*' menu no
zstyle ':completion:*' extra-verbose true
zstyle ':fzf-tab:*' continuous-trigger 'alt-space'
zstyle ':fzf-tab:*' switch-group 'alt-h' 'alt-l'

# fzf
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS='+s +m -x -e --preview-window=hidden'
export FZF_TMUX_HEIGHT=$((LINES - 15))
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# zoxide
export _ZO_FZF_OPTS="--exact --no-sort --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --border=sharp --height=95% --info=inline --layout=reverse --tabstop=1 --select-1 --preview='eza --icons --color-scale --group-directories-first {2..}' --preview-window=down,30%,sharp"

# mcfiy
export MCFLY_KEY_SCHEME=vim
export MCFLY_INTERFACE_VIEW=TOP
export MCFLY_PROMPT="❯"
export MCFLY_FUZZY=2
export MCFLY_RESULTS=25
export MCFLY_RESULTS_SORT=LAST_RUN

# ============= Alias ==============
alias sudo='sudo '

alias ip='ip -color'
alias jctl='journalctl -p 3 -xb'

alias cat='bat -p'
alias mkdir='mkdir -p'
alias cp='advcp -rvgi --reflink=always'
alias mv='advmv -vg'

alias top='btm'
alias vim='nvim'
alias ps='procs'

alias ls='eza --icons --color-scale --group-directories-first'
alias ll='ls -l --git'        # Long format, git status
alias l='ll -a'               # Long format, all files
alias lr='ll -T'              # Long format, recursive as a tree
alias lx='ll -sextension'     # Long format, sort by extension
alias lk='ll -ssize'          # Long format, largest file size last
alias lt='ll -smodified'      # Long format, newest modification time last
alias lc='ll -schanged'       # Long format, newest status change (ctime) last

alias rm='echo "别用 rm 了好吗";false'
alias tp='gtrash put'
alias tf='gtrash find'
alias te='gtrash find --rm'
alias tt='gtrash restore'
alias tg='gtrash restore-group'
alias ts='gtrash summary'

alias copy='wl-copy -n'
alias paste='wl-paste'

alias icat='kitten icat'
alias ssh='kitten ssh'

alias py='python'
alias ipy='ipython'

alias N='nvim'
alias P='paru'
alias Y='yazi'
alias T='todo.sh'
alias btp='btop'
alias lzg='lazygit'
alias lzd='lazydocker'
alias pn='pnpm'
