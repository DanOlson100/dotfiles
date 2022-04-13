# Dan's Zsh File

#Skip All for non-interactive shells
[[ -z "$PS1" ]] && return

# Enable Colors
autoload -U colors && colors

# History
HISTFILE=~/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Basic auto/tab complete with case insensitivity
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Other Options
export REPORTTIME=30
export CLICOLOR=1
export EDITOR=vim
export VISUAL=gvim

setopt AUTO_CONTINUE
setopt NOCLOBBER
setopt AUTO_CD
setopt CORRECT_ALL
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# VI Mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

zstyle :compinstall filename '~/.zshrc'

# Set user PATH if it exists
if [ -d ~/bin ]; then
    PATH=$PATH:~/bin
fi

# Setup the Aliases
if [ -f ~/.aliases ]; then 
    source ~/.aliases
fi

########## Alias definitions ##################
# FreeBSD doesn't have ls -N or ls --color=auto
# Linux has quotes but ls -N disables
# For root always show all ls -a·
# Always append indicator ls -F
if [ `uname` = "FreeBSD" ] && [ `whoami` = 'root' ]; then
    alias ls='ls -aFhG'
elif [ `uname` = "Linux" ] && [ `whoami` = 'root' ]; then
    alias ls='ls -aFhN --color=auto --group-directories-first'
elif [ `uname` = "FreeBSD" ]; then
    alias ls='ls -FhG'
else
    alias ls='ls -FhN --color=auto --group-directories-first'
fi

# Enable color support of ls¬
if [ -x /usr/bin/dircolors ]; then
    # Linux¬
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"¬
else
    # FreeBSD¬
    export CLICOLOR="1"¬
    export LSCOLORS="Exfxcxdxbxegedabagacad"¬
fi


if [ `uname` = "FreBSD" ]; then
    alias duh='du -h --max-depth=1'
    alias duhh='du -h --max-depth=1'
else
    alias duh='du -h -d1'
    alias duhh='du -h -d1'
fi

# Setup the Prompt
if [ -f ~/.zsh/git-prompt.zsh/git-prompt.zsh ];then
    source ~/.zsh/git-prompt.zsh/git-prompt.zsh
fi
PROMPT='[%(?.%F{green}OK.%F{red}?%?)%F{reset}] $(gitprompt)%F{magenta}%n%F{yellow}@%F{green}%m%F{yellow}:%F{blue}%~%F{yellow}$ %F{reset}'

# Let Vim Work in FreeNAS if there is a Jail¬
if [ `hostname -s` = "hellcat" ]; then
    alias vim='/mnt/HGST_3T/iocage/jails/JAIL_R11.3/root/usr/local/bin/vim -X'
    export VIMRUNTIME='/mnt/HGST_3T/iocage/jails/JAIL_R11.3/root/usr/local/share/vim/vim81'
fi

# Source Auto Suggestions
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Source Syntax Highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Source fzf shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && export FZF_DEFAULT_OPS="--extended"


