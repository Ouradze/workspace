"if has("autocmd")
  "autocmd! bufwritepost init.vim source ~/.vim/init.vim
"endif
"silent! source ~/.vimrc.local

" load plug_vim
call plug#begin("~/.vim/plugged")
    " Esthetics
    Plug 'joshdick/onedark.vim'
    Plug 'bling/vim-airline'
    Plug 'Yggdroot/indentLine'
    Plug 'myusuf3/numbers.vim'
    Plug 'Vimjas/vim-python-pep8-indent'

    " Completion
    Plug 'docunext/closetag.vim'
    Plug 'Raimondi/delimitMate'
    Plug 'davidhalter/jedi-vim', {'for': 'python'}
    Plug 'Shougo/Deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'zchee/deoplete-jedi'
    Plug 'ervandew/supertab'

    " Version managers
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-rhubarb'

    " Coding utilitie
    Plug 'w0rp/ale'
    Plug 'posva/vim-vue'
    Plug 'scrooloose/nerdcommenter'
    Plug 'digitaltoad/vim-pug'
    Plug 'Rykka/riv.vim'
    Plug 'Rykka/InstantRst'
    Plug 'cespare/vim-toml'

    " Linging
    Plug 'ambv/black'
    Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }

    " Workflow
    Plug 'sjl/gundo.vim', {'on': 'GundoShow'}
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'mileszs/ack.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()
" Save the folders
augroup Views
    au BufWinLeave ?* silent! mkview
    silent! au BufWinEnter ?* silent! loadview
augroup END

function! s:BaseSettings()
    syntax on
    filetype indent plugin on
    " allow backspacing over everything in insert mode
    set backspace=indent,eol,start
    set nobackup		" DON'T keep a backup file
    set nowrap				" don't wrap by default

    """"""""
    "" cmd
    """"""""
    set history=500		" keep 500 lines of command line history
    set ruler			" show the cursor position all the time
    set showcmd			" display incomplete commands
    set wildmenu        " show items list while completing in command mode
    set wildignore+=*.pyc,*.jpg,*.png,*.pdf  " prevent listing some file types
    set wildmode=list:longest,full

    """""""""
    "" search
    """""""""
    set incsearch		" do incremental searching
    set ignorecase			" ignore case
    set smartcase			" but don't ignore it, when search string contains uppercase letters

    """""""""
    "" Tabs & indent
    """""""""
    set tabstop=4
    set expandtab 		" prints 4 space characters instead of tab character
    set softtabstop=4 	" delete 4 spaces in a row
    set shiftwidth=4		" 4 characters for indenting
    set autoindent
    let g:black_skip_string_normalization = 1
    "autocmd BufWritePost *.py execute ':Black'

    """""""""
    "" look & feel
    """""""""
    set number				" line numbers
    set mouse=a				" use mouse in xterm to scroll
    set scrolloff=3 		" 5 lines bevore and after the current line when scrolling
    set title
    set colorcolumn=88

    """""""""
    "" behaviour
    """""""""
    set hid 				" allow switching buffers, which have unsaved changes
    set showmatch			" showmatch: Show the matching bracket for the last ')'?
    set nostartofline       " go to first non-blank character of line instead of beginning
    set autoread            " auto read a file when changed from the outside
    silent! set enc=utf8
    set inccommand=split
    let g:tagbar_usearrows = 1
    set diffopt=vertical
    let g:delimitMate_expand_cr = 1

    """"""""
    "" folding
    """"""""
    set foldmethod=indent
    set foldlevel=4
    set foldnestmax=3

    let g:deoplete#enable_at_startup = 1
    let g:numbers_exclude = ['minibufexpl', 'nerdtree', 'unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'term']
    let g:NERDTreeLimitedSyntax = 1
    let g:isort_command = 'isort'
    let g:NERDDefaultAlign = 'left'
endfunction
function! s:Colorscheme()
    " One dark theme
    "set antialias
    let g:onedark_termcolors = 256
    let g:onedark_terminal_italics = 1
    colorscheme onedark
endfunction
function! s:KeyMappings()
    let maplocalleader = "g"
    " select  current word
    noremap <space> viw
    " monter la ligne courante
    noremap - ddkP
    " descendre la ligne courante
    noremap _ ddp
    " supprimer la ligne courante
    inoremap <C-d> <esc>ddi
    " convertir le mot courant en majuscules
    inoremap <C-u> <esc>viwUea
    nnoremap <C-u> viwU
    " edit vimrc
    nnoremap <leader>ev :vsplit $MYVIMRC<cr>
    " surround word with "
    nnoremap <leader>" ea"<esc>hbi"<esc>lel
    " surround selection with "
    vnoremap <leader>" <esc>`<i"<esc>`>a"<esc>`<v`>ll
    " faster escape
    inoremap jk <esc>

    " get next email address
    onoremap in@ :<c-u>execute "normal! /\\S\\+@\\S\\+\r:nohlsearch\rvE"<cr>

    " Save in insert and normal mode
    inoremap <c-s> <esc>:update<cr>
    nnoremap <c-s> <c-o>:update<cr>

    " change window
    nnoremap <tab> <c-w>w
    nnoremap <S-tab> <c-w>W

    noremap <C-p> :GFiles<cr>
    noremap <C-f> :History<cr>

    nnoremap <leader>a :Ack!

    nnoremap <leader>u :GitGutterUndoHunk<cr>
    nnoremap <leader>s :GitGutterStageHunk<cr>

    nnoremap <C-d> :NERDTree

    let g:ack_mappings = {
      \ "t": "<C-W><CR><C-W>T",
      \ "T": "<C-W><CR><C-W>TgT<C-W>j",
      \ "o": "<CR>",
      \ "O": "<CR><C-W><C-W>:ccl<CR>",
      \ "go": "<CR><C-W>j",
      \ "s": "<C-W><CR><C-W>K",
      \ "S": "<C-W><CR><C-W>K<C-W>b",
      \ "v": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
      \ "gv": "<C-W><CR><C-W>H<C-W>b<C-W>J" }

    " terminal
    tnoremap sr <C-\><C-n>
endfunction
function! s:Statusline()
    " airline 
    set laststatus=2
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#ale#enabled = 1
endfunction
function! s:Completion()
    " tab completion and documentation
    let g:SuperTabDefaultCompletionType="context"
    set completeopt=menuone,longest,preview
    set showfulltag         " show full tags when doing completion
    
    " search with thesilversearcher
    let g:ackprg = 'rg --vimgrep --smart-case'
endfunction
function! s:MyPythonSettings()
    set modeline
    "set omnifunc=pythoncomplete#Complete
    let g:jedi#completions_enabled = 0
    let g:delimitMate_nesting_quotes=['""']
    " Add the virtualenv's site-packages to vim path
    if has('python')
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
    endif
    set tabstop=4  " it gets overriden by default python.nvim
endfunction
function! s:MyTexSettings()
    setlocal modeline
    setlocal tabstop=2
    setlocal softtabstop=2 	" delete 4 spaces in a row
    setlocal shiftwidth=2		" 4 characters for indenting
    setlocal conceallevel=0
    let g:vimtex_fold_enabled=1
    inoremap <buffer> × \times    
    inoremap <buffer> ÷ \div    
    inoremap <buffer> ≠ \neq    
    inoremap <buffer> ≃ \simeq    
    nnoremap <buffer> èse <plug>(vimtex-toggle-star)
    nnoremap <buffer> èsd <plug>(vimtex-toggle-delim)
endfunction
function! s:MyHTMLSettings()
    setlocal modeline
    setlocal tabstop=2
    setlocal softtabstop=2 	" delete 2 spaces in a row
    setlocal shiftwidth=2		" 2 characters for indenting
    setlocal conceallevel=0
endfunction
function! s:ResCur()
    " When editing a file, always jump to the last known cursor position.
    "Don't do it when the position is invalid or when inside an event handler
    "(happens when dropping a file on gvim).
    if line("'\"") > 0 && line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction
function s:MyJavascriptSettings()
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal conceallevel=0
    set omnifunc=javascriptcomplete#CompleteJS
    let g:ale_linters = {
                \ 'javascript': ['eslint'],
                \}
    "let g:ale_javascript_eslint_options = '-c ~/.eslintrc'
endfunction
function s:NeomakeSettings()
    let g:neomake_python_enabled_makers = ['pylint', 'flake8']
    let g:neomake_open_list = 2
endfunction
function! CSVH(colnr)
  if a:colnr > 1
    let n = a:colnr - 1
    execute 'match Keyword /^\([^,]*,\)\{'.n.'}\zs[^,]*/'
    execute 'normal! 0'.n.'f,'
  elseif a:colnr == 1
    match Keyword /^[^,]*/
    normal! 0
  else
    match
  endif
endfunction
command! -nargs=1 Csv :call CSVH(<args>)

call s:BaseSettings()
call s:Completion()
call s:Colorscheme()
call s:KeyMappings()
call s:Statusline()
" call s:NeomakeSettings()
augroup FileTypes
    autocmd!
    autocmd FileType py,python      call s:MyPythonSettings()
    autocmd FileType javascript,vue call s:MyJavascriptSettings()
    autocmd FileType html           set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css            set omnifunc=csscomplete#CompleteCSS
    autocmd FileType tex,plaintex   call s:MyTexSettings()
    autocmd FileType html           call s:MyHTMLSettings()
augroup END
augroup resCur
    autocmd!
    autocmd BufWinEnter * call s:ResCur()
augroup END

function! RunAtrFile()
    let @p=@%
    20split | term
    call feedkeys("iatr " . @p . "\<CR>", "n")
endfunction
command AtrFile call RunAtrFile()

function! RunAtrFunction()
    let currentWinNr = winnr()
    let filename = @%
    let line = getline(search("def test_.*(self)", "bn"))
    let functionname = matchstr(line, "test_[a-z_]\*")
    20split | term
    call feedkeys("iatr " . filename . " " . functionname . "\<CR>", "n")
endfunction
command AtrFun call RunAtrFunction()
