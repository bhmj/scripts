syntax enable
set wrap
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
set shiftwidth=2

" line highlight
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=235
