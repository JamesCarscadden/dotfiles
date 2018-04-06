#!/bin/bash -e

# Install git
if ! dpkg-query -W -f='${Status}' git | grep "ok installed$"
then
  sudo apt install git
fi

# Install powerline
if ! python3 -c "import powerline"
then
  pip3 install powerline-status
fi

# Install powerline fonts
if [ ! -d "$HOME/Developer/fonts" ]
then
  git clone https://github.com/powerline/fonts.git --depth=1 $HOME/Developer/fonts
  ./Developer/fonts/install.sh
fi

# Install tmux
if ! dpkg-query -W -f='${Status}' tmux | grep "ok installed$"
then
  sudo apt install tmux
fi

# Install vim (with python support)
if ! dpkg-query -W -f='${Status}' vim-nox | grep "ok installed$"
then
  sudo apt install vim-nox
fi

# Install vundle
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi

# Get dotfiles
if [ ! -d "$HOME/Developer/dotfiles" ]
then
  git clone https://bluedonkeygroup.visualstudio.com/DefaultCollection/Projects/_git/dotfiles $HOME/Developer/dotfiles
fi

# Link preferences
ln -sf $HOME/Developer/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/Developer/dotfiles/lxterminal.conf $HOME/.config/lxterminal/lxterminal.conf
ln -sf $HOME/Developer/dotfiles/lxterminal.desktop $HOME/.local/share/applications/lxterminal.desktop
lxpanelctl restart

# Install vim plugins
vim +PluginInstall +qall


