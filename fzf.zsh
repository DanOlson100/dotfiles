# Setup fzf
# ---------
if [[ ! "$PATH" == */user/Home/olson/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/user/Home/olson/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/user/Home/olson/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/user/Home/olson/.fzf/shell/key-bindings.zsh"
