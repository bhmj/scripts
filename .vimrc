" Set compatibilty to vim only
  set nocompatible
" Auto text wrapping
  set wrap


" Encoding
  set encoding=utf-8
" Show line numbers
  set number
" Status bar
  set laststatus=2
" Intent width
  set shiftwidth=2

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

call plug#end()

set nocompatible
set number
syntax enable
set fileencoding=utf-8
set encoding=utf-8
set title
set mouse=a
set autoindent
set background=dark
set nobackup
set incsearch
set hlsearch
set showcmd
set expandtab
set cmdheight=1
set laststatus=2
set scrolloff=6

"Changing default NERDTree arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

nnoremap <C-t> :NERDTreeFind<CR>

" line highlight
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=235

autocmd vimenter * NERDTree

autocmd VimEnter * NERDTreeFocus | wincmd p

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree()) | q | endif

nnoremap <C-Left> <C-w>w
nnoremap <C-Right> <C-w>W

