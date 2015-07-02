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
Plugin 'project.tar.gz'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/tComment'

call vundle#end()

syntax enable
set backspace=2
set nobackup
set nowritebackup
set ruler
set incsearch
set encoding=utf-8
set showcmd
filetype plugin indent on
set number
set numberwidth=5
set tags=./tags
set textwidth=80
set colorcolumn=+1

"" Whitespace
set nowrap
set tabstop=2 shiftwidth=2
set expandtab

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Colorscheme
set t_Co=256
colorscheme railscasts

"" Tabs
let g:miniBufExplMapWindowNavArrows=1
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

"" Syntastic
let g:syntastic_check_on_open=1


augroup vimrcEx
  autocmd!

  " When editiong a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell
augroup END


