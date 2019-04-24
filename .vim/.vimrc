
" Automatically reload vimrc on save
" autocmd BufWritePost ~/.vimrc source ~/.vimrc

" Return to last edit position when opening files again
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

"comment line
"colorscheme morning
colorscheme badwolf
syntax enable
syntax on
" You should use :x instead!
" Or you could use per https://coderwall.com/p/nckasg/map-w-to-w-in-vim
" nnoremap ; ;
command WQ wq
command Wq :echoe "you should use :x"wq
command W w
command Q q
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
set ruler
set expandtab       " tabs are spaces
set wildmenu        " visual autocomplete for command menu
set splitbelow
set splitright
set shiftwidth=2
set noswapfile      " prevent swap files (recoverable changes)
set laststatus=2    " lightline show status bar
set encoding=utf-8  " YCM requires utf-8 (and probably other stuff too)"

call plug#begin('~/.vim/plugged')

"Plugins
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/tComment'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'yggdroot/indentline'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'Lokaltog/vim-easymotion'

call plug#end()

" Not sure how these got here; gonna leave 'em for now
" let mapleader = ","
" map <Leader>n :NERDTreeToggle<CR>

map <C-n> :NERDTreeToggle<CR>

set grepprg=git\ grp\ -n

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set matchtime=3

" Allow scrolling off the page
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Starting from vim 7.3 undo can be persisted across sessions
if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

" indentline settings
let g:indentLine_char = '|'

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

