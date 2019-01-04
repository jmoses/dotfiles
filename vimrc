call pathogen#infect()
syntax on
filetype plugin indent on
"https://gist.github.com/kevinis/c788f85a654b2d7581d8
set gfn=Monaco\ for\ Powerline:h12
if has("mac") || has("macunix")
    set guifont=Monaco\ for\ Powerline:h12
end

" Colors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set t_Co=256
set background=dark
colorscheme ir_black

set number
"set relativenumber
hi CursorLineNr guifg=#660000

let g:NERDTreeWinSize=30
if has("gui_running")
	set guioptions-=T
  " For now, don't allow hidden buffers, but w/o UI (eg: no tabs)
  " we want hidden so we can leave a changed buffer w/o saving
  set nohidden
end

"set colorcolumn=80
"highlight ColorColumn guibg=#232323

set nocompatible
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set autoread "Auto reload files if they've changed (when we de-focus/focus)
set scrolloff=3
set wildignore+=.git,*.pyc,*.swp
set backspace=indent,eol,start

" Disable bell
autocmd! GUIEnter * set vb t_vb=

"Strip trailing whitespace (this moves the cursor on save. :/)
" autocmd FileType python autocmd BufWritePre <buffer> %s/\s\+$//e

autocmd FileType python,ruby EnableStripWhitespaceOnSave
let g:better_whitespace_filetypes_blacklist=['log', 'diff', 'gitcommit', 'unite', 'qf', 'help']


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

" https://gist.github.com/skanev/1068214
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction
command! CloseHiddenBuffers call s:CloseHiddenBuffers()

let g:CommandTAcceptSelectionCommand = 'GotoOrOpen e'
if has("gui_running")
  let g:CommandTAcceptSelectionTabCommand = 'GotoOrOpen tab'
end

" Don't use flake8 it's slow as balls
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

nnoremap <silent> <D-[> :lprev<CR>
nnoremap <silent> <D-]> :lnext<CR>

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
let Tlist_Show_One_File = 1
let Tlist_WinWidth = 60
let Tlist_Inc_WinWidth = 0
let Tlist_Enable_Fold_Column = 0


"regular tag support
set tags=./.tags;/

"airline
set laststatus=2 "Always show
let g:airline_theme = 'luna'
set noshowmode "Don't show vim's default mode
let g:airline#extensions#branch#enabled = 1 "Enable git integration
let g:airline_powerline_fonts = 1 "Fancy glyphs
let g:airline_section_y=''
let g:airline#extensions#whitespace#enabled = 0
au WinEnter * AirlineRefresh
" buffers
if ! has("gui_running")
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
end


" line moving
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv'

" osx gui stuff
if has("gui_macvim")
  let macvim_skip_cmd_opt_movement=1
  set macmeta
  " From macvim gvimrc
  no   <D-Left>       <Home>
  no!  <D-Left>       <Home>
  no   <M-Left>       <C-Left>
  no!  <M-Left>       <C-Left>

  no   <D-Right>      <End>
  no!  <D-Right>      <End>
  no   <M-Right>      <C-Right>
  no!  <M-Right>      <C-Right>

  no   <D-Up>         <C-Home>
  ino  <D-Up>         <C-Home>
  no   <M-Up>         {
  ino  <M-Up>         <C-o>{

  no   <D-Down>       <C-End>
  ino  <D-Down>       <C-End>
  no   <M-Down>       }
  ino  <M-Down>       <C-o>}

  ino  <M-BS>         <C-w>
  ino  <D-BS>         <C-u>
end
" SmartHomeKey
noremap <silent> <D-Left> :SmartHomeKey<CR>
imap <D-Left> <C-O><D-Left>

" buffer movement
noremap <silent> f :bn<CR>
noremap <silent> b :bp<CR>

if has("gui_running")
  "Disable vim-ruby's RI help
  autocmd FileType ruby setlocal balloonexpr=
end

"Go to last tab
" http://stackoverflow.com/questions/2119754/switch-to-last-active-tab-in-vim
let g:lasttab = 1
nmap <F10> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lattab = tabpagenr()

"Filter current buffer into newtab
"http://vi.stackexchange.com/a/4431
if has("gui_running")
  :command! -nargs=1 -range=% Filter <line1>,<line2>y z|tabnew|0put=@z|%!grep -n '<q-args>'
end


"Python
au BufNewFile,BufRead *.py set filetype=python
autocmd FileType python setlocal formatoptions+=r
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"au FileType python inoremap <D-Left> <C-O>:SmartHomeKey<CR> 

"Markdown files
au BufNewFile,BufRead *.md set filetype=markdown

" Go files
au BufRead,BufNewFile *.go set filetype=go

" Log files
au BufRead,BufNewFile *.log set filetype=log

" Clojure
au Syntax clojure,python RainbowParenthesesActivate
au Syntax clojure,python RainbowParenthesesLoadRound
au Syntax clojure,python RainbowParenthesesLoadSquare
au Syntax clojure,python RainbowParenthesesLoadBraces

" Fucking crontabs
autocmd FileType crontab setlocal nowritebackup

" Folds --- folds are annoying
"au BufWrite * mkview
"au BufRead * silent loadview

" indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" promptline
"let g:promptline_preset = {
" \'a': [ '\u' ],
" \'b': [ promptline#slices#cwd() ],
" \'y': [ promptline#slices#vcs_branch() ],
" \'warn': [ promptline#slices#last_exit_code() ]}
