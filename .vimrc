set number
set incsearch
set hlsearch
set encoding=utf-8
set scrolloff=2
syntax enable
set laststatus=2

" line highlight
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=235

