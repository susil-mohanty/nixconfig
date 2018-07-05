set tabstop=4       " Number of spaces that a <Tab> in the file counts for.

set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.

set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.

set foldmethod=syntax

set showcmd         " Show (partial) command in status line.

set number          " Show line numbers.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

set textwidth=0     " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.
set wrapmargin=0
set colorcolumn=79
set hidden          " Allow switching buffers without saving files.

set formatoptions=c,q,r " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode.
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)

set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.

set wildmode=longest:full,full " tab completion, don't complete with multiple
                               " hits

let mapleader = "\<Space>"
" let maplocalleader = "\\"
imap kk <ESC>
set relativenumber
set laststatus=2

call plug#begin('~/.vim/plugged')

Plug 'alfredodeza/pytest.vim'
Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'eugen0329/vim-esearch'
Plug 'fisadev/vim-isort'
Plug 'hashivim/vim-terraform'
Plug 'idris-hackers/idris-vim'
Plug 'itchyny/calendar.vim'
Plug 'jceb/vim-orgmode'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kassio/neoterm'
Plug 'klen/python-mode'
Plug 'LnL7/vim-nix'
Plug 'maksimr/vim-jsbeautify'
Plug 'mattn/emmet-vim'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mfulz/cscope.nvim'
Plug 'neomake/neomake'
Plug 'nvie/vim-flake8'
Plug 'pearofducks/ansible-vim'
Plug 'qpkorr/vim-bufkill'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tomlion/vim-solidity'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'jreybert/vimagit'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'

call plug#end()

" call glaive#Install()
" Glaive vtd files=`['~/todo.vtd']`
" Glaive vtd plugin[mappings] files=`['~/todo.vtd']`
" Glaive vtd plugin[mappings]='qw'


if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

syntax enable

"set clipboard+=unnamedplus

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

let g:deoplete#enable_at_startup = 1
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint = 0
" let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
" let g:pymode_lint_checkers = ['pylint'] " pylint doesn't work
" let g:loaded_python_provider = 1
" let g:python3_host_prog = '/bin/python'

" jedi call signatures
let g:jedi#show_call_signatures = 1

" run neomake on save
autocmd! BufWritePost,BufEnter * Neomake

" NEOTERM KEYBINDINGS
" let g:neoterm_position = 'horizontal'
" let g:neoterm_automap_keys = ',tt'

" nerdtree
" map <C-n> :NERDTreeToggle<CR>
" autocmd vimenter * NERDTree

" CtrlP
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

" cscope
let g:cscope_dir = '~/.nvim-cscope'
let g:cscope_map_keys = 1
let g:cscope_update_on_start = 1

nnoremap <silent> ,tsf :TREPLSendFile<cr>
nnoremap <silent> ,ts :TREPLSendLine<cr>
vnoremap <silent> ,tss :TREPLSendSelection<cr>

" escape terminal mode
tnoremap <Esc> <C-\><C-n>

" navigate in terminal mode
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" run set test lib
nnoremap <silent> ,rt :call neoterm#test#run('all')<cr>
nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
nnoremap <silent> ,rn :call neoterm#test#run('current')<cr>
nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

" Useful maps
" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>

" Git commands
command! -nargs=+ Tg :T git <args>

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#show_tab_nr = 1

" Show buffer numbers
let g:airline#extensions#tabline#buffer_nr_show = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" use powerline fonts
let g:airline_powerline_fonts = 1

let g:airline_theme='base16'


function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent> y y:call ClipboardYank()<cr>
vnoremap <silent> d d:call ClipboardYank()<cr>
nnoremap <silent> p :call ClipboardPaste()<cr>p

" delete buffer (doesn't seem to work)
" command Bd bp\|bd \#

" use 2 space indent for yml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" clang completion
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

let blacklist = ['idris']
set list listchars=trail:.,extends:>
autocmd FileWritePre * call TrimWhiteSpace()
autocmd FileAppendPre * call TrimWhiteSpace()
autocmd FilterWritePre * call TrimWhiteSpace()
autocmd BufWritePre * if index(blacklist, &ft) < 0 | call TrimWhiteSpace()

let g:indentLine_char = '┊'
let g:indentLine_color_term = 19

let g:vim_isort_python_version = "python3"
