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
Plugin 'bling/vim-airline'
Plugin 'vim-ruby/vim-ruby'
Plugin 'project.tar.gz'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/tComment'
Plugin 'TailMinusF'
Plugin 'vim-airline/vim-airline-themes'

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

"" Airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_theme='ubaryd'
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9


"" NET RW
let g:netrw_liststyle = 3
let g:netrw_winsize = 80

"" Syntastic
let g:syntastic_check_on_open=1

"" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-l>l

"" CTRL-P
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

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


