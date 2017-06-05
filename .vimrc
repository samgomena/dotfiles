"comment line
"another line
"colorscheme morning
colorscheme badwolf
syntax enable
syntax on
nnoremap <Left> :echoe "Arrow disabled: use h"<CR>
nnoremap <Right> :echoe "Arrow disabled: use l"<CR>
nnoremap <Up> :echoe "Arrow disabled: use k"<CR>
nnoremap <Down> :echoe "Arrow disabled: use j"<CR>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
inoremap jj <Esc>
inoremap kj <Esc>
set relativenumber 
set number 
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set cursorline      " highlight current line
set wildmenu        " visual autocomplete for command menu
set splitbelow
set splitright
set shiftwidth=2
set noswapfile      " prevent swap files (recoverable changes)

call plug#begin('~/.vim/plugged')

"Plugins
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'tpope/vim-rails'
Plug 'vim-scripts/tComment'
Plug 'mustache/vim-mustache-handlebars'
Plug 'junegunn/vim-easy-align'

call plug#end()

let mapleader = ","
map <Leader>n :NERDTreeToggle<CR>

set grepprg=git\ grp\ -n

"function! NumberToggle()
"  if(&relativenumber == 1)
"    set number
"  else
"    set relativenumber
"  endif
"endfunc
"
"nnoremap <C-n> :call NumberToggle()<cr>
"so /Users/Sgomena/vimrc.vim
set autochdir
