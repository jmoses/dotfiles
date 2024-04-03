" Mine settings
"noremap <silent> <C-,> :bp<CR>
"inoremap <silent> b <Esc>:bp<CR>
"noremap <silent> <C-.> :bn<CR>
"inoremap <silent> f <Esc>:bn<CR>
set hidden " let us switch buffers when one is modified
set number " line numbers
set tags=./.tags;/

if has("gui_running")
    if has("gui_gtk3") || has("macunix") || has("mac")
        set guifont=FiraCodeNF-Reg:h13
    endif
endif

" install vimplug if not installed, magic
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug
call plug#begin('~/.vim/plugged')
" sensible defaults
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'

Plug 'wgibbs/vim-irblack'
Plug 'dracula/vim', {'as': 'dracula'}

" fzf stuff
Plug '/usr/local/opt/fzf/'
Plug '/opt/homebrew/opt/fzf' " ?
Plug 'junegunn/fzf.vim'

nnoremap <silent> <C-p> :Files<CR>
inoremap <silent> <C-p> <Esc>:Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
"inoremap <silent> <Leader>b <Esc>:Buffers<CR>
"nnoremap <silent> <C-p> :GFiles --exclude-standard --others --cached<CR>
"inoremap <silent> <C-p> <Esc>:GFiles --exclude-standard --others --cached<CR>
nnoremap <silent> <F7> :BTags<CR>
inoremap <silent> <F7> <Esc>:BTags<CR>

"indentation
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=darkgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

Plug 'airblade/vim-gitgutter'


Plug 'vim-scripts/Smart-Home-Key'
if has('osx')
    noremap <D-Left> :SmartHomeKey<CR>
endif

" rainbow parenthesis
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle


" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme = 'luna'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1 "Fancy glyphs
let g:airline_section_y=''
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#enabled = 1 "Enable git integration
set noshowmode " Don't show vims status bar

" Plug 'jeetsukumaran/vim-buffergator'

" Plug 'valloric/youcompleteme'
autocmd VimEnter,Colorscheme * :hi Pmenu ctermbg=darkgrey

Plug 'vim-syntastic/syntastic'
" Don't use flake8 it's slow as balls
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" TODO: Fix this for jinja
let g:syntastic_html_checkers = []

Plug 'ervandew/supertab'
Plug 'preservim/nerdtree'


"nnoremap <silent> <D-[> :lprev<CR>
"nnoremap <silent> <D-]> :lnext<CR>

call plug#end()

set nocompatible
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set autoread "Auto reload files if they've changed (when we de-focus/focus)
set scrolloff=3
set wildignore+=.git,*.pyc,*.swp
set backspace=indent,eol,start

"set list
""set listchars=tab:>-
match Error /\t/
autocmd FileType make set noexpandtab shiftwidth=0 softtabstop=0
autocmd FileType make match none /\t/
autocmd FileType json set tabstop=2 shiftwidth=2 softtabstop=2


" envsubst filetypes
au BufRead,BufNewFile *.yaml.envsubst setf yaml

set termguicolors
colorscheme ir_black

highlight! link SignColumn LineNr
