#!/bin/bash -e

# Check system
platform='unknown'
unamestr=$(uname -a)
case "$unamestr" in
  *'armv'*)
    echo 'Rasbian'
    platform='raspberry'
    ;;
  *'Microsoft'*)
    echo 'Windows bash'
    platform='winbash'
    ;;
  'Darwin'*)
    echo 'Mac OS X'
    platform='darwin'
    ;;
esac

echo ''

# Install bash-completion
echo 'Checking for bash-completion ...'
if [ "$platform" == 'darwin' ] && ! brew ls --versions bash-completion > /dev/null
then
  brew install bash-completion
else
  echo 'bash-completion already installed'
fi

echo ''

# Install git
# Assume already installed on darwin
echo "Checking for git ..."
if [ ! "$platform" ==  'darwin' ] && ! dpkg-query -W -f='${Status}' git | grep "ok installed$" > /dev/null
then
  sudo apt install git
else
  echo "Git already installed"
fi

echo ""

# Install pip
echo "Checking for pip ..."
if [ ! "$platform" == 'darwin' ] && ! dpkg-query -W -f='${Status}' python3-pip | grep "ok installed$" > /dev/null
then
  sudo apt install python3-pip
  pip3 install --upgrade pip
elif [ "$platform" == 'darwin' ] && ! brew ls --versions python3 > /dev/null
then
  brew install python3
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
  if ! [ "$platform" == 'winbash' ]
  then
    $HOME/Developer/fonts/install.sh
  else
    /mnt/c/windows/syswow64/WindowsPowerShell/v1.0/powershell.exe -File C:\\Users\\james\\AppData\\Local\\Packages\\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\\LocalState\\rootfs\\home\\james\\Developer\\fonts\\install.ps1
  fi
else
  echo "Fonts already installed, getting latest"
  cd $HOME/Developer/fonts;git pull;cd $HOME
  if ! [ "$platform" == 'winbash' ]
  then
    $HOME/Developer/fonts/install.sh
  else
    /mnt/c/windows/syswow64/WindowsPowerShell/v1.0/powershell.exe -File C:\\Users\\james\\AppData\\Local\\Packages\\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\\LocalState\\rootfs\\home\\james\\Developer\\fonts\\install.ps1
  fi
fi

# Alter console fonts
if [ $platform == 'linux' ] || [ "$platform" == 'raspberry' ]
then
  echo "Setting up console font ..."
  sudo cp $HOME/Developer/fonts/Terminus/PSF/*.psf.gz /usr/share/consolefonts
  sudo cp /etc/default/console-setup /etc/default/console-setup.bak
  sudo echo 'FONT="ter-powerline-v18n.psf.gz"' > /etc/default/console-setup
fi

echo ""

# Install tmux
echo "Checking for tmux ..."
if [ ! "$platform" == 'darwin' ] && ! dpkg-query -W -f='${Status}' tmux | grep "ok installed$" > /dev/null
then
  sudo apt install tmux
elif [ "$platform" == 'darwin' ] && ! brew ls --versions tmux > /dev/null
then
  brew install tmux
else
  echo "tmux already installed"
fi

echo ""

# Install vim (with python support)
echo "Checking for vim with scripting support ..."
if [ ! "$platform" == 'darwin' ] && ! dpkg-query -W -f='${Status}' vim-nox | grep "ok installed$" > /dev/null
then
  sudo apt install vim-nox
elif [ "$platform" == 'darwin' ] && ! brew ls --versions macvim > /dev/null
then
  brew install macvim --with-override-system-vim
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
echo "Linking dotfiles ..."
ln -sf $HOME/Developer/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/Developer/dotfiles/gitconfig $HOME/.gitconfig
ln -sf $HOME/Developer/dotfiles/tmux.conf $HOME/.tmux.conf

if [ "$platform" == 'raspberry' ]
then
  ln -sf $HOME/Developer/dotfiles/lxterminal.conf $HOME/.config/lxterminal/lxterminal.conf
  ln -sf $HOME/Developer/dotfiles/lxterminal.desktop $HOME/.local/share/applications/lxterminal.desktop
  lxpanelctl restart
fi

if [ "$platform" == 'darwin' ]
then
  ln -sf $HOME/Developer/dotfiles/bashrc_darwin $HOME/.bashrc
  ln -sf $HOME/Developer/dotfiles/bash_profile_darwin $HOME/.bash_profile
fi

if [ "$platform" == 'winbash' ]
then
  ln -sf $HOME/Developer/dotfiles/bashrc_windows $HOME/.bashrc
fi

echo ""

# Install vim plugins
echo "installing vim plugins ..."
vim +PluginInstall +qall


