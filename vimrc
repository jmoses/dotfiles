call pathogen#infect()
syntax on
filetype plugin indent on
set gfn=Monaco:h12
set background=dark
colorscheme ir_black
set number
let g:NERDTreeWinSize=30
if has("gui_running")
	set guioptions-=T
end

set nocompatible
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

" CTRLp
let g:ctrlp_working_path_mode = 2
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
