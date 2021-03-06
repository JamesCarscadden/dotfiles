set nocompatible
filetype on

"" Vundle stuff
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'ScrollColors'
Plugin 'fugitive.vim'
Plugin 'rails.vim'
Plugin 'Railscasts-Theme-GUIand256color'
Plugin 'tpope/vim-bundler'
Plugin 'vim-ruby/vim-ruby'
Plugin 'project.tar.gz'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/tComment'
Plugin 'TailMinusF'

call vundle#end()

syntax enable
set backspace=2
set nobackup
set nowritebackup
set ruler
set encoding=utf-8
set showcmd
filetype plugin indent on
set number
set numberwidth=5
set tags=./tags
set textwidth=80
set colorcolumn=+1
set showmatch
set splitbelow
set splitright
let mapleader="\\"

"" Font
if has("gui_running")
  if has("gui_gtk2")
    ""set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Literation\ Mono\ Powerline:h14
  elseif has("gui_win32")
    set guifont=Inconsolata_for_Powerline:h14:cANSI
  endif
endif

"" Whitespace
set nowrap
set tabstop=2 shiftwidth=2
set expandtab
set list listchars=tab:»·,trail:·,nbsp:·

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Colorscheme
set t_Co=256
colorscheme railscasts

"" NET RW
let g:netrw_liststyle = 3
let g:netrw_winsize = 80
let g:netrw_banner = 0
let g:netrw_browse_split = 3


"" Syntastic
let g:syntastic_check_on_open=1

"" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-l>l

"" CTRL-P
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*\\node_modules\\*

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
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


