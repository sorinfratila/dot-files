"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #1 VIM/NEOVIM SPECIFIC
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
	set termguicolors
	let g:python_host_prog = '/usr/local/bin/python'
	let g:python3_host_prog = '/usr/local/bin/python3'
endif
if !has('nvim')
	set ttyfast
        set ttymouse=xterm2
	set t_Co=256
	set nocompatible
	filetype off                  " required
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #2 PLUGIN MANAGER & AUTOCOMMANDS
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Plugin manager
call plug#begin('~/.vim/plugged')

"navigation & searching
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf',  { 'dir': '~/.fzf',  'do': './install --all'  }
Plug 'tweekmonster/fzf-filemru'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/Tagbar', { 'on': 'TagbarToggle' }
Plug 'tmhedberg/SimpylFold'
Plug 'terryma/vim-smooth-scroll'
Plug 'vim-scripts/Tabmerge'
Plug 'wesQ3/vim-windowswap'

"graphical improvements
Plug 'neomake/neomake'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'morhetz/gruvbox'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'matze/vim-move'
Plug 'tpope/vim-repeat'
Plug 'edkolev/tmuxline.vim'

"text completion & editing
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'berdandy/AnsiEsc.vim'
Plug 'vim-scripts/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'

"---------------------------------------------------
"python indentation
Plug 'nvie/vim-flake8', { 'for': 'python' }
"plist filetype support
Plug 'darfink/vim-plist', {'for': 'plist'}
"indenting
Plug 'Yggdroot/indentLine'
"git plugin
Plug 'tpope/vim-fugitive'

call plug#end()
filetype plugin indent on    " required

" load autocomplete and code snippets at launch
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| autocmd! load_us_ycm
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #3 COLOR SETTINGS & FILETYPE
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
" Color Scheme
colors gruvbox
set background=dark
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'readonly': 'LightLineReadonly',
      \   'modified': 'LightLineModified',
      \   'filename': 'LightLineFilename'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! LightLineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightLineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return ""
  else
    return ""
  endif
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

" tmuxline
"au VimEnter * :Tmuxline lightline -- if theme was not exported
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : ['#(whoami)', '#(uptime | grep -ohe "up.*, [0-9] u" | sed "s/, [0-9] u//")'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(cmus-remote -Q | grep "stream" | sed "s/stream/♬/")',
      \'y'    : ['%R', '%a  %b %d', '%Y'],
      \'z'    : '#(hostname | sed "s/Tomass-MacBook.local/macbook/")'}

" Flagging Unnecessary Whitespace and syntax checking
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
autocmd! BufWritePost * Neomake
" Line and numbers highlighting
set cursorline
autocmd BufRead,BufNewFile * hi LineNr ctermbg=237
set numberwidth=6

" Plist editing syntax - (vim-plist converts plist to xml)
let g:plist_display_format = 'xml'

" hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set relativenumber nu 	" line numbering

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #4 KEY BINDINGS & CONTROLL
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable methods folding
set foldmethod=indent
set foldlevel=99
" Enable methods folding with the spacebar
nnoremap <Leader><Leader> za
map <C-n> :NERDTreeToggle<CR>
map <C-t> :Tagbar<CR>
nnoremap <silent>≤ :tabnext<CR>
nnoremap <silent>¯ :tabprev<CR>
nnoremap <silent>tn :tabnew<Space>
nnoremap <silent>Ò :tabm +<CR>
nnoremap <silent>Ó :tabm -<CR>
"current tab merge to split
nnoremap <silent>ts :Tabmerge left<Cr>
"current split to new tab
nnoremap <silent>st <C-W>T
"split horizontal/vertical
nnoremap <silent>sv :vs<CR>
nnoremap <silent>sh :split<CR>
"circle between splits by Alt-comma
nnoremap , <C-w><C-w>
"Alt-W as Ctrl-W (C-W) used in tmux
nnoremap ∑ <C-W>
"split resizing
nnoremap <silent><Right> :vertical resize +5<CR>
nnoremap <silent><Left> :vertical resize -5<CR>
nnoremap <silent><Up> :res +5<CR>
nnoremap <silent><Down> :res -5<CR>
let mapleader =' '
nnoremap <Leader>j O<Esc>
nnoremap <Leader>k o<Esc>
nnoremap <Leader>l i<CR><Esc>
nnoremap <Leader>s :sv<CR>
nnoremap <Leader>v :vs<CR>
nnoremap <Leader>q :q!<CR>
nnoremap <Leader>w :w!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>R :source ~/.vimrc<CR>:PlugInstall<CR>
"text editing
nnoremap <tab> >>
nnoremap <S-tab> <<
nnoremap <leader><tab> i<tab><Esc>
nnoremap <leader><S-Tab> wi<BS><Esc>
nnoremap // :set hlsearch! hlsearch?<cr>
inoremap , ,<space>
" moving text via vim-move
let g:move_key_modifier = 'S'
nnoremap <S-h> i<BS><Esc>
nnoremap <S-l> i<CR><Esc>
nnoremap <silent>~~ :set invpaste paste?<CR>

" wrap text by comment
vnoremap <Leader>. :call NERDComment(0, "toggle")<CR>
nnoremap <Leader>. :call NERDComment(0, "toggle")<CR>

" fzf-vim
let g:fzf_layout = { 'down': '~25%' }
nnoremap <C-p> :Files<CR>
"nnoremap <C-m> :FilesMru<CR>
nnoremap <C-m> :History<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <Leader><C-p> :Files Dropbox/<CR>
nnoremap <silent><Leader>/ :History/<CR>
nnoremap <silent><Leader>: :History:<CR>

" autocompletion
set omnifunc=syntaxcomplete#Complete
let g:ycm_auto_trigger = 1
let g:SimpylFold_docstring_preview=1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion = 2
map <Leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" number column settings
nnoremap <silent><Leader>n :set relativenumber? norelativenumber!<CR>
autocmd InsertEnter,FocusLost * :set norelativenumber
autocmd InsertLeave,FocusGained * :set relativenumber

" clipboard from system
set clipboard=unnamed

" Smooth Scroll
noremap <silent> <c-e> :call smooth_scroll#up(&scroll,  0,  2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll,  0,  2)<CR>
noremap <silent> <c-k> :call smooth_scroll#up(&scroll*2,  0,  4)<CR>
noremap <silent> <c-j> :call smooth_scroll#down(&scroll*2,  0,  4)<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
syntax on

au BufRead,BufNewFile *.applescript setf applescript

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " 'cindent' is on in C files, etc.
  filetype plugin indent on

  augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif
