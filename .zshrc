#############################################################
#	PATHS, ALIASES & MISC
#############################################################
# Homebrew binaries and scripts before system ones
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/opt/ruby/bin:$PATH

#Fuzzy search plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias tmux for proper coloring
export TERM='xterm-256color'

# Zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

#FZF - use ag to search
export FZF_DEFAULT_COMMAND="ag -l -uG '^(?!.*\.(pvm|iso|dmg)).*$'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# cmus notifications enable
export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Lang setting
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Key timeout
export KEYTIMEOUT=1

# tmux autostart
ZSH_TMUX_AUTOSTART="true"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Set name of the theme to load.
POWERLEVEL9K_CONTEXT_TEMPLATE=""

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Date format in history
HIST_STAMPS="dd/mm/yyyy"

alias G="cd /Volumes/Mac\ HD/Users/tomasizo/Dropbox/Documents/Git/"
alias vim='nvim'
alias cc='pwd | tr -d '\n' | pbcopy'
#############################################################
#	PLUGIN MANAGER
#############################################################
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Bundles
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "uvaes/fzf-marks"
zplug "plugins/git",  from:oh-my-zsh, as:plugin
zplug "plugins/z",  from:oh-my-zsh, as:command
zplug "plugins/osx",  from:oh-my-zsh, as:plugin
zplug "plugins/tmux",  from:oh-my-zsh, as:plugin
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

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

prompt_context() {
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=(
    "ROOT"      "yellow"
    "DEFAULT"   "white"
  )

  local content=""

  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_CONTEXT" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then

      if [[ $(print -P "%#") == '#' ]]; then
        current_state="ROOT"
      fi

      content="${POWERLEVEL9K_CONTEXT_TEMPLATE}"

  elif [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]]; then
      content="$(whoami)"
  else
      return
  fi

  "$1_prompt_segment" "${0}_${current_state}" "$2" "$DEFAULT_COLOR" "${context_states[$current_state]}" "${content}"
}

right_prompt_segment() {  }
#############################################################
#	TEST
#############################################################
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
