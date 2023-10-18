#!/bin/sh

# Check system
platform='unknown'
unamestr=$(uname -a)
case "$unamestr" in
  *'aarch'*)
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
  sudo apt install -y git git-credential-oauth
else
  echo "Git already installed"
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


# Check for zsh
echo "Checking for Zsh"
if ! zsh --version > /dev/null
then
  if [ ! "$platform" == 'darwin' ]
  then
    echo "Installing Zsh"
    sudo apt install -y zsh
    echo "Setting default shell to Zsh"
    sudo chsh -s /bin/zsh $USER
    echo "Restart terminal and bootstrap script"
    exit
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

# Create Fonts Dir
if [ ! -d "$HOME/.local/share/fonts" ]
then
  mkdir "$HOME/.local/share/fonts"
fi

# Get SourceCode Pro nerdfont
echo "Getting SourceCode Pro nerdfont"
curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf > ~/.local/share/fonts/SauceCodeProNerdFontMono-Regular.ttf
fc-cache -f

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
  sudo apt install -y tmux
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
  sudo apt install -y vim-nox
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
  if [ ! -d "$HOME/.cache" ]
  then
    mkdir "$HOME/.cache"
  fi
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
vim +PluginInstall +qall || true

echo ""

# Install kubectl
echo "installing kubernetes kubectl ..."
if [ ! "$platform" == 'darwin' ]
then
  if ! which kubectl > /dev/null
  then
    sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update && sudo apt-get install -y kubectl
  fi
fi

echo ""

# install podman
echo "installing podman"
if [ ! "$platform" == 'darwin' ]
then
  if ! which podman > /dev/null
  then
    sudo apt-get update && sudo apt-get install -y podman
  fi
fi

echo ""

# install rtx
echo "installing rtx ..."
if [ ! "$platform" == 'darwin' ] && ! dpkg-query -W -f='${Status}' rtx | grep "ok installed$" > /dev/null
then
  wget -qO - https://rtx.pub/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/rtx-archive-keyring.gpg 1> /dev/null
  if [ "$platform" == 'raspberry' ]
    echo "deb [signed-by=/etc/apt/keyrings/rtx-archive-keyring.gpg arch=arm64] https://rtx.pub/deb stable main" | sudo tee /etc/apt/sources.list.d/rtx.list
  elif
    echo "deb [signed-by=/etc/apt/keyrings/rtx-archive-keyring.gpg arch=amd64] https://rtx.pub/deb stable main" | sudo tee /etc/apt/sources.list.d/rtx.list
  fi
  sudo apt install -y rtx
elif [ "$platform" == 'darwin' ] && ! brew ls --versions rtx > /dev/null
then
  brew install rtx
else
  echo "rtx already installed"
fi

# install ruby with rtx
# install node with rtx

# install visual studio code
echo "installing VSCode ..."
if [ ! "$platform" == 'darwin' ]
then
  if ! which code > /dev/null
  then
    curl -OL https://aka.ms/linux-arm64-deb
    sudo apt install -y ./code*deb
    rm code*deb
  fi
fi