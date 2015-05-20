call pathogen#infect()
syntax on
filetype plugin indent on
"https://gist.github.com/kevinis/c788f85a654b2d7581d8
set gfn=Monaco\ for\ Powerline:h12
if has("mac") || has("macunix")
    set guifont=Monaco\ for\ Powerline:h12
end
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
function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

let g:CommandTAcceptSelectionCommand = 'GotoOrOpen e'
let g:CommandTAcceptSelectionTabCommand = 'GotoOrOpen tab'

nnoremap <silent> <C-p> :CommandT<CR>
nnoremap <silent> <F5> :CommandTFlush<CR>
let g:CommandTMaxHeight=35
" May want this as per-project, but how?
let g:CommandTTraverseSCM='pwd'


"Taglist
nnoremap <silent> <F6> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Sort_Type = "name"
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

"airline
set laststatus=2 "Always show
let g:airline_theme = 'luna'
set noshowmode "Don't show vim's default mode
let g:airline#extensions#branch#enabled = 1 "Enable git integration
let g:airline_powerline_fonts = 1 "Fancy glyphs

if has("gui_running")
  "Disable vim-ruby's RI help
  autocmd FileType ruby setlocal balloonexpr=
end

"Go to last tab
" http://stackoverflow.com/questions/2119754/switch-to-last-active-tab-in-vim
let g:lasttab = 1
nmap <F10> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lattab = tabpagenr()

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
