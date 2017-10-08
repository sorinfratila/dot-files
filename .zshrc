#Fuzzy search plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias tmux for proper coloring
alias tmux="env TERM=xterm-256color tmux"
export TERM='xterm-256color'

#############################################################
#	PLUGIN MANAGER
#############################################################
source ~/.antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles
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
#############################################################
#	PATHS, ALIASES & MISC
#############################################################
#FZF - use ag to search
export FZF_DEFAULT_COMMAND="ag -l -uG '^(?!.*\.(pvm|iso|dmg)).*$'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# cmus notifications enable
export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Homebrew binaries and scripts before system ones
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/opt/ruby/bin:$PATH

# Lang setting
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Key timeout
export KEYTIMEOUT=1

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Set name of the theme to load.
ZSH_THEME="cobalt2"
ZSH_TMUX_AUTOSTART="true"

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Date format in history
HIST_STAMPS="dd/mm/yyyy"

alias G="cd /Volumes/Mac\ HD/Users/tomasizo/Dropbox/Documents/Git/"
alias vim='nvim'
alias cc='pwd | tr -d '\n' | pbcopy'

#############################################################
#	KEY BINDINGS
#############################################################
bindkey -v
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey '^h' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^p' fzf-file-widget
bindkey '^O' fzf-cd-tmux-widget
bindkey '^E' fzf-history-widget
bindkey '\`' autosuggest-clear
bindkey '^ ' autosuggest-accept
bindkey '^g' jump
#############################################################
#	FUNCTIONS
#############################################################
function zle-line-init zle-keymap-select {
    VIM_NORM="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    VIM_INS="%{$fg_bold[green]%} [% INSERT]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_NORM}/(main|viins)/$VIM_INS }$EPS1"
    zle reset-prompt
}


zle -N zle-line-init
zle -N zle-keymap-select

fzf-cd-tmux-widget() {
	local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune     -o -type d -print 2> /dev/null | cut -b3-"}"
	setopt localoptions pipefail 2> /dev/null
	local dir=$(eval "$cmd" | fzf-tmux -d 30%)
	if [[ -z "$dir" ]]
	then
		zle redisplay
		return 0
	fi
	cd "$dir"
	local ret=$?
	zle reset-prompt
	typeset -f zle-line-init > /dev/null && zle zle-line-init
        return $ret
}
zle -N fzf-cd-tmux-widget
#############################################################
#	TEST
#############################################################
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
