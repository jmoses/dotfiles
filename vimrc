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

"set colorcolumn=80
"highlight ColorColumn guibg=#232323

set nocompatible
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set scrolloff=3
set wildignore+=.git

"CommandT
nnoremap <silent> <C-p> :CommandT<CR>
let g:CommandTMaxHeight=35
