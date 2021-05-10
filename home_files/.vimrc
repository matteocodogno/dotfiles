syntax on

set autoindent
set relativenumber
set ts=2
set sts=2
set shiftwidth=2
set softtabstop=2
set tabstop=2
filetype plugin indent on

:set cursorline

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

