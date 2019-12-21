#!/bin/sh

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

# Check for zsh
echo "Checking for Zsh"
if ! zsh --version > /dev/null
then
  if [ ! "$platform" == 'darwin' ]
  then
    echo "Installing Zsh"
    sudo apt install zsh
    echo "Setting default shell to Zsh"
    chsh -s /bin/zsh
  fi
else
  echo "Zsh already installed"
fi

echo ""

# Install oh-my-zsh
echo "Checking for oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]
then
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already installed"
fi

echo ""

# Install Powerlevel10k theme for oh-my-zsh
echo "Checking for powerlevel10k theme"
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]
then
  echo "installing powerlevel10k theme for oh-my-zsh"
  git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
else
  echo "powerlevel10k theme already installed"
fi

echo ""

# Alter console fonts
# if [ $platform == 'linux' ] || [ "$platform" == 'raspberry' ]
# then
#   echo "Setting up console font ..."
#   sudo cp $HOME/Developer/fonts/Terminus/PSF/*.psf.gz /usr/share/consolefonts
#   sudo cp /etc/default/console-setup /etc/default/console-setup.bak
#   sudo echo 'FONT="ter-powerline-v18n.psf.gz"' > /etc/default/console-setup
# fi

# echo ""

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
  git clone https://github.com/JamesCarscadden/dotfiles.git $HOME/Developer/dotfiles
else
  echo "dotfiles already present, getting latest"
  cd $HOME/Developer/dotfiles;git pull;cd $HOME
fi

echo ""

# Link preferences
echo "Linking dotfiles ..."
ln -sf $HOME/Developer/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/Developer/dotfiles/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/Developer/dotfiles/tmux.conf.local $HOME/.tmux.conf.local
ln -sf $HOME/Developer/dotfiles/zshrc $HOME/.zshrc
ln -sf $HOME/Developer/dotfiles/p10k.zsh $HOME/.p10k.zsh

if [ "$platform" == 'darwin' ]
then
  ln -sf $HOME/Developer/dotfiles/gitconfig.darwin $HOME/.gitconfig
else
  ln -sf $HOME/Developer/dotfiles/gitconfig $HOME/.gitconfig
fi

# Create Cache Dir
if [ ! -d "$HOME/.cache/zsh" ]
then
  echo "Create Cache Dir"
  mkdir "$HOME/.cache/zsh"
fi

if [ "$platform" == 'raspberry' ]
then
  ln -sf $HOME/Developer/dotfiles/lxterminal.conf $HOME/.config/lxterminal/lxterminal.conf
  ln -sf $HOME/Developer/dotfiles/lxterminal.desktop $HOME/.local/share/applications/lxterminal.desktop
  lxpanelctl restart
fi

echo ""

# Install vim plugins
echo "installing vim plugins ..."
vim +PluginInstall +qall
