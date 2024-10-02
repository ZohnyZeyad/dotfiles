# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

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
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Home Bin
export PATH=$PATH:$HOME/bin

# Aliases
alias ls='ls --color'
alias c='clear'
alias prettyjson='python3 -m json.tool'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# OpenVPN 3
alias vpn-start='openvpn3 session-start --config /home/zeyad-zohny/Downloads/nxvpn.ovpn'
alias vpn-disc='openvpn3 session-manage --config /home/zeyad-zohny/Downloads/nxvpn.ovpn --disconnect'
export PATH=$HOME/.local/bin:$PATH

# fnm
FNM_PATH="/home/zeyad-zohny/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/zeyad-zohny/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Apache Spark
export SPARK_HOME=/opt/spark/spark-3.5.2-bin-hadoop3-scala2.13
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3

# ActiveMQ
export ACTIVEMQ_PATH=/home/zeyad-zohny/apache-activemq-5.18.5
export PATH=$PATH:$ACTIVEMQ_PATH/bin

# IDEA
export PATH="/snap/intellij-idea-ultimate/current/bin:$PATH"
alias idea='/snap/intellij-idea-ultimate/current/bin/idea.sh'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# bootdev
export PATH=$PATH:$HOME/go/bin

# tmux
export TMUX_SCRIPTS=$HOME/.local/scripts
export PATH=$PATH:$TMUX_SCRIPTS
bindkey -s ^f "tmux-sessionizer\n"

# RTA
# MAST REPORT SERVICE
export MONGO_MAST_STAGING_PASSWORD=cXn3zIalz3sIrgxv
export MONGO_COREV2_STAGING_PASSWORD=fuOUme8hG0GWZHn4

# Okta
alias okta="flatpak run com.okta.developer.CLI"

# tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
