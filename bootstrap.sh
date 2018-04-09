#!/bin/bash -e

# Check system
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  echo "Linux"
  platform='linux'
elif [[ "$unamestr" == *'Microsoft'* ]]; then
  echo "Windows bash"
  platform='winbash'
fi

echo ""

# Install git
echo "Checking for git ..."
if ! dpkg-query -W -f='${Status}' git | grep "ok installed$" > /dev/null
then
  sudo apt install git
else
  echo "Git already installed"
fi

echo ""

# Install pip
echo "Checking for pip ..."
if ! dpkg-query -W -f='${Status}' python3-pip | grep "ok installed$" > /dev/null
then
  sudo apt install python3-pip
else
  echo "pip already installed"
fi

echo ""

# Install powerline
echo "Checking for powerline ..."
if ! python3 -c "import powerline" > /dev/null
then
  pip3 install powerline-status
else
  echo "Powerline installed"
fi

echo ""

# Install powerline fonts
echo "Checking for powerline fonts ..."
if [ ! -d "$HOME/Developer/fonts" ]
then
  git clone https://github.com/powerline/fonts.git --depth=1 $HOME/Developer/fonts
  $HOME/Developer/fonts/install.sh
else
  echo "Fonts already installed, getting latest"
  cd $HOME/Developer/fonts;git pull;cd $HOME
  $HOME/Developer/fonts/install.sh
fi

# Alter console fonts
if [ $platform == 'linux' ]
then
  echo "Setting up console font ..."
  sudo cp $HOME/Developer/fonts/Terminus/PSF/*.psf.gz /usr/share/consolefonts
  sudo cp /etc/default/console-setup /etc/default/console-setup.bak
  echo 'FONT="ter-powerline-v18n.psf.gz"' > /etc/default/console-setup
fi

echo ""

# Install tmux
echo "Checking for tmux ..."
if ! dpkg-query -W -f='${Status}' tmux | grep "ok installed$" > /dev/null
then
  sudo apt install tmux
else
  echo "tmux already installed"
fi

echo ""

# Install vim (with python support)
echo "Checking for vim with scripting support ..."
if ! dpkg-query -W -f='${Status}' vim-nox | grep "ok installed$" > /dev/null
then
  sudo apt install vim-nox
else
  echo "vim with scripting already installed"
fi

echo ""

# Install vundle
echo "Checking for Vundle ..."
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
else
  echo "Vundle already installed, getting latest"
  cd $HOME/.vim/bundle/Vundle.vim;git pull;cd $HOME
fi

echo ""

# Get dotfiles
echo "Checking for dotfiles ..."
if [ ! -d "$HOME/Developer/dotfiles" ]
then
  git clone https://bluedonkeygroup.visualstudio.com/DefaultCollection/Projects/_git/dotfiles $HOME/Developer/dotfiles
else
  echo "dotfiles already present, getting latest"
  cd $HOME/Developer/dotfiles;git pull;cd $HOME
fi

echo ""

# Link preferences
ln -sf $HOME/Developer/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/Developer/dotfiles/gitconfig $HOME/.gitconfig
ln -sf $HOME/Developer/dotfiles/tmux.conf $HOME/.tmux.conf
#ln -sf $HOME/Developer/dotfiles/lxterminal.conf $HOME/.config/lxterminal/lxterminal.conf
#ln -sf $HOME/Developer/dotfiles/lxterminal.desktop $HOME/.local/share/applications/lxterminal.desktop
#lxpanelctl restart

# Install vim plugins
vim +PluginInstall +qall


