# zmodload zsh/zprof

# Configure color-scheme
COLOR_SCHEME=dark
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Disable auto updates
zstyle ':omz:update' mode disabled

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
# if [ ! -d "$ZINIT_HOME" ]; then
#    mkdir -p "$(dirname $ZINIT_HOME)"
#    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
source ~/.zsh_profile

# mkdir -p ${ZDOTDIR:-~}/.zsh_functions
# echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
fpath+=${ZDOTDIR:-~}/.zsh_functions

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Bloop
fpath=($HOME/.local/share/coursier/bin/bloop/zsh $fpath)

# Disable unneeded completions
# while IFS= read -r completion_name; do
#   zinit cdisable "$completion_name" &>/dev/null
# done < "${ZDOTDIR:-$HOME}/.zinit_cdisable"

# Add in zsh plugins
zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light lukechilds/zsh-better-npm-completion

export NVM_DIR="$HOME/.config/nvm"
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_NO_USE=true
# zinit ice wait lucid for cloneonly; zinit light lukechilds/zsh-nvm

# Add in snippets
zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::sudo

zinit ice wait lucid
zinit snippet OMZP::sbt

zinit ice wait lucid
zinit snippet OMZP::mvn

zinit ice wait lucid
zinit snippet OMZP::gradle

zinit ice wait lucid
zinit snippet OMZP::mongocli

zinit ice wait lucid
zinit snippet OMZP::docker-compose

zinit ice wait lucid
zinit snippet OMZP::aws

zinit ice wait lucid
zinit snippet OMZP::terraform

zinit ice wait lucid
zinit snippet OMZP::command-not-found

zinit ice wait lucid for atinit"
        ZSH_TMUX_FIXTERM=true;
        ZSH_TMUX_AUTOSTART=false;
        ZSH_TMUX_AUTOCONNECT=true;"
zinit snippet OMZP::tmux

# zinit ice wait lucid
# zinit snippet OMZP::kubectl

# zinit ice wait lucid
# zinit snippet OMZP::kubectx

# zinit ice wait lucid
# zinit snippet OMZP::conda

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Load completions
autoload -Uz compinit; compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

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

# Completion styling
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Home Bin
export PATH=$PATH:$HOME/bin
export PATH="$PATH:/opt/nvim-linux64/bin"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Aliases
alias vim='nvim'

### Colorize commands
alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias c='clear'
alias prettyjson='python3 -m json.tool'
alias curl='curlie'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

### CAT & LESS
command -v bat > /dev/null && \
	alias bat='bat --theme=ansi' && \
	alias cat='bat --style=plain --pager=never' && \
	alias less='bat'

### LS & TREE
alias ll='ls -la'
alias la='ls -A'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree -I ".git"'

# Shell integrations
# export FZF_DEFAULT_COMMAND='find .'
# export FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'
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
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"

# OpenVPN 3
alias vpn-start="openvpn3 session-start --config $HOME/Downloads/nxvpn.ovpn"
alias vpn-disc="openvpn3 session-manage --config $HOME/Downloads/nxvpn.ovpn --disconnect"
export PATH=$HOME/.local/bin:$PATH

# Apache Spark
export SPARK_HOME=/opt/spark/spark-3.5.4-bin-hadoop3
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3

# ActiveMQ
export ACTIVEMQ_PATH=$HOME/apache-activemq-5.18.5
export PATH=$PATH:$ACTIVEMQ_PATH/bin

# IDEA
export PATH="/snap/intellij-idea-ultimate/current/bin:$PATH"
alias idea='/snap/intellij-idea-ultimate/current/bin/idea.sh'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# bootdev
export PATH=$PATH:$HOME/go/bin

export PATH=$PATH:$HOME/.local/scripts

# cargo
export PATH=$PATH:$HOME/.cargo/bin

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Okta
alias okta="flatpak run com.okta.developer.CLI"

# Maven
export MAVEN_OPTS="-Xms2g -Xmx4g"

# Lombok
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# zprof > ~/.dotfiles/tmp/zprof
