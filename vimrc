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
set wildignore+=.git,*.pyc

"CommandT
nnoremap <silent> <C-p> :CommandT<CR>
nnoremap <silent> <F5> :CommandTFlush<CR>
let g:CommandTMaxHeight=35

"Taglist
nnoremap <silent> <F6> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Sort_Type = "name"
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

if has("gui_running")
  "Disable vim-ruby's RI help
  autocmd FileType ruby setlocal balloonexpr=
end

"Python
au BufNewFile,BufRead *.py set filetype=python
autocmd FileType python setlocal formatoptions+=r
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

"Markdown files
au BufNewFile,BufRead *.md set filetype=markdown

" Go files
au BufRead,BufNewFile *.go set filetype=go

" Folds
au BufWrite * mkview
au BufRead * silent loadview

" indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
