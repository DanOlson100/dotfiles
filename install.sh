#!/bin/sh

export localdir=`/usr/bin/dirname $0`
echo "Linking from:: $localdir  to  ~/"

#ln -s $localdir/aliases        ~/.aliases
#ln -s $localdir/bashrc         ~/.bashrc
#ln -s $localdir/dircolors      ~/.dircolors
#ln -s $localdir/fzf.bash       ~/.fzf.bash
#ln -s $localdir/fzf.zsh        ~/.fzf.zsh
#ln -s $localdir/gitconfig      ~/.gitconfig
#ln -s $localdir/init.lua       ~/.config/nvim/init.lua
#ln -s $localdir/screenrc       ~/.screenrc
#ln -s $localdir/tmux.conf      ~/.tmux.conf
#ln -s $localdir/vimrc          ~/.vimrc
#ln -s $localdir/zshrc          ~/.zshrc

cp -f $localdir/aliases        ~/.aliases
cp -f $localdir/bashrc         ~/.bashrc
cp -f $localdir/dircolors      ~/.dircolors
cp -f $localdir/filetypes.vim  ~/.vim/filetypes.vim
cp -f $localdir/fzf.bash       ~/.fzf.bash
cp -f $localdir/fzf.zsh        ~/.fzf.zsh
cp -f $localdir/gitconfig      ~/.gitconfig
cp -f $localdir/init.lua       ~/.config/nvim/init.lua
cp -f $localdir/screenrc       ~/.screenrc
cp -f $localdir/tmux.conf      ~/.tmux.conf
cp -f $localdir/vimrc          ~/.vimrc
cp -f $localdir/zshrc          ~/.zshrc

