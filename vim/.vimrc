syntax on

colorscheme darkblue

set tabstop=4
set softtabstop=4
set expandtab

set scroll=10

set number

filetype indent on 

set lazyredraw

set wildmenu

set showmatch

set incsearch

inoremap kj <C-C> 

vnoremap kj <C-C>

cnoremap kj <C-C>
"makes escape more comfortable

let mapleader = ","

vnoremap <leader>y "+y
nnoremap <leader>p "+p
"yanks and pastes to and from the clipboard register

nnoremap <leader>ev :vsp ~/.vimrc<cr>
"opens vimrc in a vertical split

nnoremap <leader>sv :so ~/.vimrc<cr>
"sources vimrc so any saved changes have effect on the current buffer

noremap <leader>t :sh<cr>
