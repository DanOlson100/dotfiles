# Dan's Bashrc File

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Don't do Core Dumps
ulimit -S -c 0

# Other Optiosn
set -o ignoreeof
#set -o nounset

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set Color Prompt
if [ `whoami` = 'root' ]; then
    export PS1="${debian_chroot:+($debian_chroot)}[B] \[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[33m\]:\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[33m\]\\$\[\e[m\] "
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    export PS1="${debian_chroot:+($debian_chroot)}[B] \[\e[35m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[33m\]:\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[33m\]\\$\[\e[m\] "
    
    # Add Git Stuff to Prompt
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_START="[_LAST_COMMAND_INDICATOR_] [B]"
    GIT_PROMPT_END=" \[\e[35m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[33m\]:\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[33m\]\\$\[\e[m\] "
    source ~/.bash-git-prompt/gitprompt.sh
    
fi

# Set user PATH if it exists
if [ -d ~/bin ]; then
    PATH=$PATH:~/bin
fi

# Enable programmable 33completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set Editor
EDITOR="vim"
export EDITOR

########## Alias definitions ##################
# Linux has quotes but ls -N disables
# For root always show all ls -a 
# Always append indicator ls -F
if [ `whoami` = 'root' ]; then
    alias ls='ls -aFhN --color=auto --group-directories-first'
else
    alias ls='ls -FhN --color=auto --group-directories-first'
fi

# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    # Linux
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

#################################################
# Functions
#################################################

#Extract things
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1;;
            *.tar.gz)    tar xzf $1;;
            *.bz2)       bunzip2 $1;;
            *.rar)       rar x $1;;
            *.gz)        gunzip $1;;
            *.tar)       tar xf $1;;
            *.tbz2)      tar xjf $1;;
            *.tgz)       tar xzf $1;;
            *.zip)       unzip $1;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1;;
            *)           echo "'$1' cannot be extracted via extract()";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Source fzf Shell Integration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

