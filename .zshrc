#Fuzzy search plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias tmux for proper coloring
alias tmux="env TERM=xterm-256color tmux"

source ~/.antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundles <<EOBUNDLES
	git
	z
	osx
	tmux
	zsh-users/zsh-autosuggestions
	zsh-users/zsh-syntax-highlighting
	zsh-users/zsh-completions
	zsh-users/zsh-history-substring-search
	uvaes/fzf-marks
EOBUNDLES

# Tell antigen that you're done.
antigen apply

export TERM='xterm-256color'

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

#FZF - use ag to search
export FZF_DEFAULT_COMMAND="ag -l -uG '^(?!.*\.(pvm|iso|dmg)).*$'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set name of the theme to load.
ZSH_THEME="cobalt2"
ZSH_TMUX_AUTOSTART="true"

# cmus notifications enable
export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Date format in history
HIST_STAMPS="dd/mm/yyyy"
source $ZSH/oh-my-zsh.sh

# Homebrew binaries and scripts before system ones
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/opt/ruby/bin:$PATH

# Lang setting
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Compilation flags
export ARCHFLAGS="-arch x86_64"

#############################################################
# Key Bindings
bindkey -v
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey '^h' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^p' fzf-file-widget
bindkey '^O' fzf-cd-widget
bindkey '^E' fzf-history-widget
bindkey '\`' autosuggest-clear
bindkey '^ ' autosuggest-accept
bindkey '^g' jump

function zle-line-init zle-keymap-select {
    VIM_NORM="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    VIM_INS="%{$fg_bold[green]%} [% INSERT]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_NORM}/(main|viins)/$VIM_INS }$EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

#############################################################
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Plugins, Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git osx tmux)

#############################################################

# Aliases (example: -alias zshconfig="mate ~/.zshrc")
alias G="cd /Volumes/Mac\ HD/Users/tomasizo/Dropbox/Documents/Git/"
alias vim='nvim'
alias cc='pwd | tr -d '\n' | pbcopy'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
