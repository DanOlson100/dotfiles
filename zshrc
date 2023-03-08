# Dan's Zsh File
#
# These are the Git Plug-ins Needed
#  https://github.com/woefe/git-prompt.zsh
#  https://github.com/zsh-users/zsh-autosuggestions
#  https://github.com/zsh-users/zsh-syntax-highlighting
#  https://github.com/softmoth/zsh-vim-mode
#  https://github.com/shaunsauve/zsh-dirhistory.git
#  the git-prompt needs a utf-8 

# Enable Colors
autoload -U colors && colors

# History Settings
HISTFILE=~/.zsh_histfile       # History Save File
HISTSIZE=100                   # Size of history in a session
SAVEHIST=1000                  # Size of history file
setopt INC_APPEND_HISTORY      # Add items to the history file imediately
setopt HIST_IGNORE_ALL_DUPS    # Remove old dup commands from the history
setopt HIST_IGNORE_SPACE       # Don't write commands that start with spaces to the history file
setopt HIST_REDUCE_BLANKS      # Remove multiple blanks from commands in the history
setopt HIST_VERIFY             # Show command with history expansion (!*) to user before running it 
setopt EXTENDED_HISTORY        # Add timestamps to the history file
setopt SHARE_HISTORY           # Share history between terminals

# Basic auto/tab complete with case insensitivity, substring search and coloring
# The last line is for globing dotfiles.
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Report CPU Time > 30s
# Set CLI Color and Editors
export REPORTTIME=30
export CLICOLOR=1
export EDITOR=vim
export VISUAL=gvim
export SHELL=`which zsh`
export HOST=`hostname`
export LANG=en_US.UTF-8
#export LC_ALL="en_US.UTF-8"

# Set Options
setopt AUTO_CONTINUE  # Auto send a job a CONT signal
setopt NO_CLOBBER     # Don't clobber exiting files w/ redirect 
setopt AUTO_CD        # If cmd is a dir, auto cd in
setopt CORRECT_ALL    # Try to auto correct arg spelling
setopt AUTO_LIST      # Auto list choices on an ambiguous completion
setopt AUTO_MENU      # Use menu completion after the 2nd request for completion
setopt ALWAYS_TO_END  # Goto End on completion
setopt PROMPT_SUBST   # If set prompt get cmd sub and arith expansion

# Enable VI Key Mode
bindkey -v
export KEYTIMEOUT=1

# Create new Keymap
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

# Create new Keymap
# Setup vi insert emulation
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Set Cursor shape on startup
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;} 

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
[ -d ~/bin ] && PATH=$PATH:~/bin

# Setup the Aliases
[ -f ~/.aliases ] && source ~/.aliases

########## Alias definitions ##################
# Linux has quotes but ls -N disables
# For root always show all ls -a·
# Always append indicator ls -F
if [ `whoami` = 'root' ]; then
    alias ls='ls -aFhN --color=auto --group-directories-first'
else
    alias ls='ls -FhN --color=auto --group-directories-first'
fi

# Enable color support of ls¬
if [ -x /usr/bin/dircolors ]; then
    # Linux¬
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"¬
fi

# Enable alternate cmds if available
[ -f '/usr/bin/nala'   ] && alias apt='nala'
[ -f '/usr/bin/exa'    ] && alias ls='exa -Fh --color=auto --group-directories-first'
[ -f '/usr/bin/batcat' ] && alias cat='batcat'

# Setup Auto Suggestions Plugin
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Setup Syntax Highlighting Plugin
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Setup Dir History Plugin
[ -f ~/.zsh/zsh-dirhistory/dirhistory.plugin.zsh ] && source ~/.zsh/zsh-dirhistory/dirhistory.plugin.zsh

# Setup Vim Mode Plugin (Needs setopt PROMP_SUBST)
[ -f  ~/.zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh ] && source ~/.zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh
MODE_INDICATOR_VIINS='%F{2}I%f'
MODE_INDICATOR_VICMD='%F{1}C%f'
MODE_INDICATOR_REPLACE='%F{4}R%f'
MODE_INDICATOR_SEARCH='%F{5}S%f'
MODE_INDICATOR_VISUAL='%F{14}V%f'
MODE_INDICATOR_VLINE='%F{6}L%f'

# Load the Git Promp Plugin and setup the Prompt
[ -f ~/.zsh/git-prompt.zsh/git-prompt.zsh ] && source ~/.zsh/git-prompt.zsh/git-prompt.zsh
PROMPT='[%(?.%F{green}OK.%F{red}?%?)%F{reset}] [Z] [${MODE_INDICATOR_PROMPT}] $(gitprompt)%F{magenta}%n%F{yellow}@%F{green}%m%F{yellow}:%F{blue}%~%F{yellow}$ %F{reset}'
RPS1=""

# Source fzf shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && export FZF_DEFAULT_OPS="--extended"

# Source Software Versions
[ -f ~/.version ] && source ~/.version

# Add the Nala AutoComplete if it Exists
[ -d ~/.zsh/.zfunc ] && fpath+=~/.zsh/.zfunc

# Move Keys to the End so they are not overwrote by Pluggins
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h'  vi-backward-char
bindkey -M menuselect 'k'  vi-up-line-or-history
bindkey -M menuselect 'l'  vi-forward-char
bindkey -M menuselect 'j'  vi-down-line-or-history

# Add some VI keys
bindkey -M viins      'jj' vi-cmd-mode
bindkey -M vicmd      'H'  vi-beginning-of-line
bindkey -M vicmd      'L'  vi-end-of-line

# Use Arrow Keys to Search History
# Use showkey -a to get key shortcuts
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
#bindkey "$terminfo[kcuu1]" history-beginning-search-backward
#bindkey "$terminfo[kcud1]" history-beginning-search-forward

# Set the Key timeout in 100th of a second
export KEYTIMEOUT=100

