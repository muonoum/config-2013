set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

Bundle 'baskerville/vim-sxhkdrc'
Bundle 'gmarik/vundle'
Bundle 'kana/vim-altr'
Bundle 'kana/vim-smartword'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'nanotech/jellybeans.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'w0ng/vim-hybrid'

let mapleader = '\'

filetype plugin indent on

syntax on

color hybrid "jellybeans

highlight Normal ctermbg=None

if has("autocmd")
    autocmd! FileType c set commentstring=//\ %s
    autocmd! BufNewFile,BufRead *sxhkdrc* :set ft=sxhkdrc
    autocmd! BufNewFile,BufRead *.coffee :set ft=coffee
    autocmd! BufNewFile,BufRead *vimperatorrc :set ft=vim
    autocmd! BufNewFile,BufRead *.h :set ft=c
    autocmd! BufWritePost .vimrc source $HOME/.vimrc
    autocmd! BufWritePost *
    \   if filereadable('tags') |
    \       call system('ctags -R ' . expand('%')) |
    \   endif
endif

set autoindent
set backspace=indent,eol,start
set expandtab
set guioptions-=L
set guioptions-=T
set guioptions-=b
set guioptions-=e
set guioptions-=m
set guioptions-=r
set hlsearch
set ignorecase
set incsearch
set list
set listchars=tab:>-,trail:-
set nowrap
set number
set ruler
set scrolloff=1
set shiftwidth=4
set shortmess=filnxtToOI
set showcmd
set smartcase
set softtabstop=4
set splitbelow splitright
set tabstop=4
set textwidth=0
set wildignore+=*.o,*.d

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

map <silent> <leader>sa :call Altropen('sp')<cr>
map <silent> <leader>a :call Altropen('edit')<cr>
map <silent> <leader>va :call Altropen('vsp')<cr>

nmap <leader>V :source $HOME/.vimrc<cr>
nmap <leader>vv :vs $HOME/.vimrc<cr>
nmap <leader>v :tabedit $HOME/.vimrc<cr>
nmap <leader>sv :sp $HOME/.vimrc<cr>

nmap <leader>vm :vs Makefile<cr>
nmap <leader>m :e Makefile<cr>
nmap <leader>sm :sp Makefile<cr>

nmap <leader>cc :CoffeeCompile<cr>
nmap <leader>cm :CoffeeMake<cr>

nmap <leader>xx :close<cr>

cmap <C-A> <C-B>

nmap Q <nop>

nnoremap <cr> <esc>
vnoremap <cr> <esc>gV
onoremap <cr> <esc>
inoremap <cr> <esc>`^

nmap <c-j> <c-w>w
nmap <c-k> <c-w>W

nmap <leader>xw :%s/\s\+$//e<cr>

nmap <leader><cr> :nohlsearch<cr>

nmap <leader>d :diffupdate<cr>
nmap <leader>w :set wrap!<cr>
imap <leader>d <esc>:diffupdate<cr>i
imap <leader>w <esc>:set wrap!<cr>i

nmap <leader>ub :BundleInstall!<cr>
nmap <leader>b  :BundleInstall<cr>
nmap <leader>cb :BundleClean<cr>

nmap <c-p> :CtrlPCurWD<cr>
nmap <c-S-p> :CtrlP<cr>
