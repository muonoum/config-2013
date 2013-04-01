set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

" Bundle 'FuzzyFinder'
" Bundle 'L9'
" Bundle 'vim-conque'
" Bundle 'colorv.vim'
" Bundle 'kana/vim-operator-user'
" Bundle 'kana/vim-textobj-entire'
" Bundle 'kana/vim-textobj-diff'
" Bundle 'kana/vim-textobj-indent'
" Bundle 'kana/vim-operator-replace'
" Bundle 'kana/vim-niceblock'
" Bundle 'kana/vim-textobj-underscore'
" Bundle 'sjl/gundo.vim'
" Bundle 'godlygeek/tabular'
" Bundle 'kana/vim-smartword'
" Bundle 'michaeljsmith/vim-indent-object'
" Bundle 'tpope/vim-speeddating'
" Bundle 'kana/vim-textobj-user'
" Bundle 'kana/vim-textobj-function'
" Bundle 'vim-ruby/vim-ruby'
" Bundle 'snipMate'
" Bundle 'kana/vim-smartinput'
" Bundle 'a.vim'

Bundle 'gmarik/vundle'
Bundle 'nanotech/jellybeans.vim'
Bundle 'w0ng/vim-hybrid'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'kchmck/vim-coffee-script'
Bundle 'baskerville/vim-sxhkdrc'
Bundle 'SirVer/ultisnips'
Bundle 'Raimondi/delimitMate'
Bundle 'kana/vim-altr'

filetype plugin indent on

" let g:ctrlp_working_path_mode = 2
" let g:gundo_right = 1

let g:UltiSnipsSnippetDirectories = ["snippets"]
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-s>"

let g:hybrid_use_Xresources = 1

set timeoutlen=500
set shortmess=filnxtToOI
set number
set ruler
set wrap
set pastetoggle=<leader>.
set nrformats=
set linebreak
set textwidth=0
set showbreak=
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set expandtab
set splitbelow splitright
set autoindent
set wildmode=longest,list
set hlsearch
set ignorecase
set smartcase
set incsearch
set ff=unix
set virtualedit=all
set showcmd
set hidden
set backspace=indent,eol,start
set novisualbell
set noerrorbells
set vb t_vb=
set nowrap
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=b
set guioptions-=e
set foldmethod=marker
set scrolloff=1
set pastetoggle=<leader>.
set t_Co=256

"color jellybeans
color hybrid

syntax on

if has("autocmd")
  autocmd! BufWritePost .vimrc source $MYVIMRC
  autocmd! BufWritePre * :set ff=unix
  autocmd! BufWritePre * :%s/\s\+$//e
  autocmd! BufNewFile,BufRead *sxhkdrc* :set ft=sxhkdrc
  autocmd! BufNewFile,BufRead *.coffee :set ft=coffee
  autocmd! BufNewFile,BufRead *vimperatorrc :set ft=vim
  autocmd! BufNewFile,BufRead *.h :set ft=c
  autocmd! FileType c set commentstring=//\ %s
endif

if has("win32")
  set guifont=dina:h8
else
  set directory=/tmp//
endif

let mapleader=","

nmap <leader>sa <Plug>(altr-sforward)
nmap <leader>a  <Plug>(altr-forward)
nmap <leader>va <Plug>(altr-vforward)

map <c-o> :only<cr>
map <c-h> 5<c-w><
map <c-l> 5<c-w>>
map <c-j> <c-w>w
map <c-k> <c-w>W
map <leader>v :tabedit $MYVIMRC<cr>
map <leader>ew :e <C-R>=expand("%:p:h")."/"<cr>
map <leader>es :sp <C-R>=expand("%:p:h")."/"<cr>
map <leader>ev :vsp <C-R>=expand("%:p:h")."/"<cr>
map <leader>et :tabe <C-R>=expand("%:p:h")."/"<cr>
map <leader>cw :cd <C-R>=expand("%:p:h")."/"<cr>
map <leader><cr> :nohlsearch<cr>
map <leader>w :set wrap!<cr>
imap <leader>w <esc>:set wrap!<cr>i
map <leader>d :diffupdate<cr>
imap <leader>d <esc>:diffupdate<cr>i

map <leader>vm :vs Makefile<cr>
map <leader>m :e Makefile<cr>
map <leader>sm :sp Makefile<cr>
map <leader>xx :bd<cr>
map <leader>cc :CoffeeCompile<cr>
map <leader>cm :CoffeeMake<cr>
cmap <C-A> <C-B>
nnoremap <leader>g :GundoToggle<cr>
nnoremap <leader>b :BundleInstall<cr>
nnoremap <leader>bb :BundleInstall!<cr>
nnoremap <leader>bc :BundleClean<cr>
nnoremap <cr> <esc>
vnoremap <cr> <esc>gV
onoremap <cr> <esc>
inoremap <cr> <esc>`^
inoremap <c-a> <c-p>
inoremap <leader><tab> <tab>
map Q <nop>
vmap > >gv
vmap < <gv

" highlight Normal ctermbg=Black
" highlight Normal ctermbg=Black
" highlight NonText ctermbg=Black
" highlight LineNr ctermbg=Black
highlight TabLine gui=bold
highlight TabLineSel gui=bold
highlight StatusLine gui=bold
highlight StatusLine gui=bold
highlight StatusLineNC gui=bold
highlight Folded gui=none
highlight Comment gui=bold
