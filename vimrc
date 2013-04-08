set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

Bundle 'Lokaltog/vim-easymotion'
Bundle 'baskerville/vim-sxhkdrc'
Bundle 'gmarik/vundle'
Bundle 'goldfeld/vim-seek'
Bundle 'kana/vim-altr'
Bundle 'kana/vim-smartword'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'nanotech/jellybeans.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'w0ng/vim-hybrid'
Bundle 'kbarrette/mediummode'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'

let mapleader = '\'

filetype plugin indent on

syntax on

" color jellybeans
color hybrid

highlight Normal ctermbg=none guibg=black
highlight EasyMotionTarget ctermbg=none ctermfg=160 cterm=bold
highlight EasyMotionShade ctermbg=none ctermfg=238

sign define dummy

if has('autocmd')
    au! FileType c set commentstring=//\ %s
    au! BufNewFile,BufRead *sxhkdrc* :set ft=sxhkdrc
    au! BufNewFile,BufRead *.coffee :set ft=coffee
    au! BufNewFile,BufRead *vimperatorrc :set ft=vim
    au! BufNewFile,BufRead *.h :set ft=c
    au! BufWritePost .vimrc source $HOME/.vimrc
    au! VimResized * :wincmd =
    au! WinEnter,BufWinEnter,CursorHold * checktime
    au! BufEnter * sign define dummy
    au! BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
    au! BufReadPost *
        \   if line("'\"") > 1 && line("'\"") <= line("$") |
        \       exe "norm! g`\"" |
        \   endif
    au! BufWritePost *
        \   if filereadable('tags') |
        \       call system('ctags -R *') |
        \   endif
endif

if has('gui_running')
    set guioptions-=L
    set guioptions-=T
    set guioptions-=b
    set guioptions-=e
    set guioptions-=m
    set guioptions-=r

    set cursorline
endif

set autoindent
set autoread
set backspace=indent,eol,start
set complete=.,i,]
set completeopt=longest,menuone,preview
set expandtab
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set list
set listchars=tab:>-,trail:-
set nowrap
set number
set relativenumber
set ruler
set scrolloff=1
set shiftwidth=4
set shortmess=filnxtToOI
set showcmd
set sidescrolloff=2
set smartcase
set softtabstop=4
set splitbelow splitright
set tabstop=4
set textwidth=0
set undodir=$HOME/.vim/undo
set undofile
set undoreload=10000
set virtualedit=all
set wildignore+=*.o,*.d
set wildmenu
set cpoptions+=n

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

function! Gotochar()
    let chars = ['(', ')', '''', '"', '[', ']', '{', '}', '<', '>']
    let min = min(filter(map(chars, "stridx(getline('.'), v:val, col('.'))"), "v:val >= 0"))
    if min >= 0
        execute 'norm!'.(min+1).'|'
    endif
endfunction

function! Altropen(dir)
    let path = altr#_infer_the_missing_path(bufname('%'), 'forward', altr#_rule_table())

    if path isnot 0
        let buf = bufnr(printf('^%s$', path))
        let win = bufwinnr(buf)

        if buf == -1 || win == -1
            execute a:dir . ' `=path`'
        else
            execute win 'wincmd w'
        endif
    endif
endfunction

function! Swap(n1, n2)
    let b1 = winbufnr(a:n1)
    let b2 = winbufnr(a:n2)
    exe 'buf' . b2
    exe a:n2 . "wincmd w"
    exe 'buf' . b1
endfunction

function! Swapprev()
    if (winnr() - 1) != 0
        call Swap(winnr(), winnr() - 1)
    else
        call Swap(winnr(), winnr('$'))
    endif
endfunction

function! Swapnext()
    if winbufnr(winnr() + 1) != -1
        call Swap(winnr(), winnr() + 1)
    else
        call Swap(winnr(), 1)
    endif
endfunction

function! Resize(dir)
    if winnr() == winnr('$')
        wincmd W
        exec "vertical resize " . a:dir
        wincmd w
    else
        exec "vertical resize " . a:dir
    endif
endfunction

nnoremap <F10> :YcmForceCompileAndDiagnostics<cr>

nmap <silent> <c-o> :call Swapnext()<cr>
nmap <silent> <c-i> :call Swapprev()<cr>
nmap <c-j> <c-w>w
nmap <c-k> <c-w>W
nmap <silent> <c-h> :call Resize('-5')<cr>
nmap <silent> <c-l> :call Resize('+5')<cr>

nmap <leader>V :source $HOME/.vimrc<cr>
nmap <leader>vv :vs $HOME/.vimrc<cr>
nmap <leader>v :tabedit $HOME/.vimrc<cr>
nmap <leader>sv :sp $HOME/.vimrc<cr>

nmap <leader>ub :BundleInstall!<cr>
nmap <leader>vb :BundleInstall<cr>
nmap <leader>cb :BundleClean<cr>

nmap <c-p> :CtrlPCurWD<cr>
nmap <c-S-p> :CtrlP<cr>
nmap <c-t> :CtrlPTag<cr>

nmap <silent> <leader>sa :call Altropen('sp')<cr>
nmap <silent> <leader>a :call Altropen('edit')<cr>
nmap <silent> <leader>va :call Altropen('vsp')<cr>

nmap <leader>w <Plug>(smartword-w)
nmap <leader>b <Plug>(smartword-b)
nmap <leader>e <Plug>(smartword-e)
nmap <leader>ge <Plug>(smartword-ge)

nmap <leader>cc :CoffeeCompile<cr>
nmap <leader>cm :CoffeeMake<cr>

nmap <leader>vm :vs Makefile<cr>
nmap <leader>m :e Makefile<cr>
nmap <leader>sm :sp Makefile<cr>

nmap <leader>xx :close<cr>

cmap <C-A> <C-B>

nmap Q <nop>
nmap K <nop>

vmap <leader>p "_dP

nnoremap <cr> <esc>
vnoremap <cr> <esc>gV
onoremap <cr> <esc>
inoremap <cr> <esc>`^

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nmap <silent> <leader>xw mz :%s/\s\+$//e<cr>`z:noh<cr>

nmap <leader><cr> :nohlsearch<cr>

nmap <leader>d :diffupdate<cr>
imap <leader>d <esc>:diffupdate<cr>i

nmap <leader>tw :set wrap!<cr>
imap <leader>tw <esc>:set wrap!<cr>i
