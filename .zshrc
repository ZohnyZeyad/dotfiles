# zmodload zsh/zprof

# ~~~~~~~~~~~~~~~ Powerlevel10K ~~~~~~~~~~~~~~~~~~~~~~~~

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ~~~~~~~~~~~~~~~ Configure Color Scheme ~~~~~~~~~~~~~~~~~~~~~~~~

COLOR_SCHEME=dark

# ~~~~~~~~~~~~~~~ Disable Auto Updates ~~~~~~~~~~~~~~~~~~~~~~~~

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
zstyle ':omz:update' mode disabled

# ~~~~~~~~~~~~~~~ Setup Environment ~~~~~~~~~~~~~~~~~~~~~~~~

set -o vi
source ~/.zsh_profile

if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt extended_glob null_glob

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~

path=(
    $path
    $HOME/bin
    $HOME/.local/bin
    $HOME/.local/bin
    $HOME/.local/scripts
    $HOME/.local/share/coursier/bin
    $HOME/go/bin
    $HOME/.cargo/bin
    /opt/nvim-linux64/bin
    $SPARK_HOME/bin
    $SPARK_HOME/sbin
    $ACTIVEMQ_PATH/bin
    $IDEA_PATH/bin
    $CONDA_PATH/bin
)

# Remove duplicate entries and non-existent directories
typeset -U path
path=($^path(N-/))

export PATH

fpath=($HOME/.local/share/coursier/bin/bloop/zsh $fpath)

export LD_LIBRARY_PATH=/opt/openssl/lib:$LD_LIBRARY_PATH

# ~~~~~~~~~~~~~~~ Keybindings ~~~~~~~~~~~~~~~~~~~~~~~~

bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;5D' vi-backward-blank-word
bindkey '^[[1;5C' vi-forward-blank-word
bindkey '^[[1;3D' vi-backward-word
bindkey '^[[1;3C' vi-forward-word
bindkey '^H' vi-backward-kill-word
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' delete-word

# ~~~~~~~~~~~~~~~ ZINIT ~~~~~~~~~~~~~~~~~~~~~~~~

# Set zinit plugin directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# mkdir -p ${ZDOTDIR:-~}/.zsh_functions
# echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
fpath+=${ZDOTDIR:-~}/.zsh_functions

# ~~~~~~~~~~~~~~~ Zinit Plugins ~~~~~~~~~~~~~~~~~~~~~~~~

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice wait lucid; zinit light zsh-users/zsh-completions
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid; zinit light Aloxaf/fzf-tab
zinit ice wait lucid; zinit light lukechilds/zsh-better-npm-completion
# zinit ice wait lucid for cloneonly; zinit light lukechilds/zsh-nvm

# ~~~~~~~~~~~~~~~ Zinit Snippets ~~~~~~~~~~~~~~~~~~~~~~~~

zinit ice wait lucid; zinit snippet OMZP::git
zinit ice wait lucid; zinit snippet OMZP::sudo
zinit ice wait lucid; zinit snippet OMZP::sbt
zinit ice wait lucid; zinit snippet OMZP::mvn
zinit ice wait lucid; zinit snippet OMZP::gradle
zinit ice wait lucid; zinit snippet OMZP::mongocli
zinit ice wait lucid; zinit snippet OMZP::docker-compose
zinit ice wait lucid; zinit snippet OMZP::aws
zinit ice wait lucid; zinit snippet OMZP::terraform
zinit ice wait lucid; zinit snippet OMZP::command-not-found
zinit ice wait lucid; zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid for atinit"
        ZSH_TMUX_FIXTERM=true;
        ZSH_TMUX_AUTOSTART=false;
        ZSH_TMUX_AUTOCONNECT=true;"
zinit snippet OMZP::tmux
# zinit ice wait lucid; zinit snippet OMZP::kubectl
# zinit ice wait lucid; zinit snippet OMZP::kubectx
# zinit ice wait lucid; zinit snippet OMZP::conda

# ~~~~~~~~~~~~~~~ Completions ~~~~~~~~~~~~~~~~~~~~~~~~

autoload -Uz compinit; compinit
compinit -U

zinit cdreplay -q

# ~~~~~~~~~~~~~~~ Completions Styling ~~~~~~~~~~~~~~~~~~~~~~~~

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

alias vim='nvim'
alias v='nvim'
alias c='clear'
alias curl='curlie'
alias ll='ls -la'
alias la='ls -A'
alias lzd='lazydocker'
alias lzg='lazygit'

alias idea=$IDEA_PATH/bin/idea.sh
alias okta="flatpak run com.okta.developer.CLI"
alias vpn-start="openvpn3 session-start --config nxvpn"
alias vpn-disc="openvpn3 session-manage --config nxvpn --disconnect"

# ~~~~~~~~~~~~~~~ Colorize Commands ~~~~~~~~~~~~~~~~~~~~~~~~

alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias prettyjson='python3 -m json.tool'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

command -v bat > /dev/null && \
	alias bat='bat --theme=ansi' && \
	alias cat='bat --style=plain --pager=never' && \
	alias less='bat'

command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree -I ".git"'

# ~~~~~~~~~~~~~~~ Shell Integrations ~~~~~~~~~~~~~~~~~~~~~~~~

export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND="find \! \( -path '*/.git' -prune \) -printf '%P\n'"
export FZF_DEFAULT_OPTS="
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
    --bind 'space:become(nvim {})'
    --preview='bat -n --color=always {}'"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xsel --clipboard --input)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {} | head -200'"
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

# ~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~

source <(fzf --zsh)

eval "$(zoxide init --cmd cd zsh)"

[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# zprof > ~/.dotfiles/tmp/zprof
