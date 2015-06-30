set nocompatible
filetype off

"" Vundle stuff
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'ScrollColors'
Plugin 'fugitive.vim'
Plugin 'rails.vim'
Plugin 'Railscasts-Theme-GUIand256color'
Plugin 'tpope/vim-bundler'
Plugin 'bling/vim-airline'
Plugin 'vim-ruby/vim-ruby'
Plugin 'minibufexpl.vim'
Plugin 'project.tar.gz'

call vundle#end()

syntax enable
set encoding=utf-8
set showcmd
filetype plugin indent on
set number
set tags=./tags

"" Whitespace
set nowrap
set tabstop=2 shiftwidth=2
set expandtab
set backspace=indent,eol,start

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Colorscheme
set t_Co=256
colorscheme railscasts

"" Tabs
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWIndowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1

"" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='ubaryd'

"" NET RW
let g:netrw_liststyle = 3
let g:netrw_winsize = 80
