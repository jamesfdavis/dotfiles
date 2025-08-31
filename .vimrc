" Modern .vimrc Configuration for 2025
" Enhanced Vim setup for software development

"==============================================================================
" Basic Settings
"==============================================================================

" Disable Vi compatibility for enhanced features
set nocompatible

" Set encoding to UTF-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" Enable file type detection and plugins
filetype on
filetype plugin on
filetype indent on

" Use system clipboard (requires +clipboard)
if has('clipboard')
  set clipboard=unnamed,unnamedplus
endif

" Leader key
let mapleader = ","
let g:mapleader = ","

"==============================================================================
" Visual & Interface
"==============================================================================

" Enable syntax highlighting
syntax on

" Color scheme and background
set background=dark
if has('termguicolors')
  set termguicolors
endif

" Try modern color schemes with fallbacks
silent! colorscheme onedark
if !exists('g:colors_name') || g:colors_name !=# 'onedark'
  silent! colorscheme gruvbox
endif
if !exists('g:colors_name') || g:colors_name !=# 'gruvbox'
  silent! colorscheme solarized
endif
if !exists('g:colors_name')
  colorscheme desert
endif

" Line numbers
set number
set relativenumber

" Current line highlighting
set cursorline

" Show ruler and status
set ruler
set laststatus=2
set showcmd
set showmode

" Better status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" Window title
set title

" Remove startup message
set shortmess+=I

"==============================================================================
" Indentation & Formatting
"==============================================================================

" Smart indentation
set autoindent
set smartindent
set smarttab

" Tab settings (spaces over tabs)
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Auto-formatting options
set textwidth=80
set wrap
set linebreak

" Show invisible characters
set list
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮

"==============================================================================
" Search & Replace
"==============================================================================

" Enhanced searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Clear search highlighting
nnoremap <silent> <leader><space> :noh<CR>

"==============================================================================
" Editor Behavior
"==============================================================================

" Backspace behavior
set backspace=indent,eol,start

" Scrolling
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Cursor movement
set nostartofline

" Better completion
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*~,*.pyc,*.class,*.git,*.svn,node_modules

" Mouse support
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  endif
endif

" Terminal optimization
set ttyfast
set lazyredraw

"==============================================================================
" File Management
"==============================================================================

" Backup and swap files
set backup
set writebackup
set swapfile

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backups")
  call mkdir($HOME."/.vim/backups", "p", 0700)
endif
if !isdirectory($HOME."/.vim/swaps")
  call mkdir($HOME."/.vim/swaps", "p", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
  call mkdir($HOME."/.vim/undo", "p", 0700)
endif

set backupdir=~/.vim/backups//
set directory=~/.vim/swaps//

" Persistent undo
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo//
  set undolevels=1000
  set undoreload=10000
endif

" Skip backup for temporary files
set backupskip=/tmp/*,/private/tmp/*,/var/tmp/*

"==============================================================================
" Security & Modelines
"==============================================================================

" Enable modelines with security
set modeline
set modelines=4

" Secure mode for project-specific .vimrc
set exrc
set secure

"==============================================================================
" Key Mappings
"==============================================================================

" Better escape
inoremap jk <Esc>
inoremap kj <Esc>

" Save shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>W :w !sudo tee % > /dev/null<CR>

" Quit shortcuts
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Split resizing
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Better Y behavior (like D and C)
nnoremap Y y$

" Center screen on jump
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Move lines up/down
nnoremap <leader>k :m-2<CR>
nnoremap <leader>j :m+<CR>
vnoremap <leader>k :m-2<CR>gv
vnoremap <leader>j :m'>+<CR>gv

"==============================================================================
" Functions & Commands
"==============================================================================

" Strip trailing whitespace
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
command! StripWhitespace call StripWhitespace()
nnoremap <leader>ss :call StripWhitespace()<CR>

" Toggle relative line numbers
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunction
nnoremap <leader>n :call NumberToggle()<CR>

" Toggle paste mode
set pastetoggle=<F2>

" Format JSON
function! FormatJSON()
  %!python -m json.tool
endfunction
command! FormatJSON call FormatJSON()

" Format XML
function! FormatXML()
  %!xmllint --format -
endfunction
command! FormatXML call FormatXML()

"==============================================================================
" File Type Specific Settings
"==============================================================================

if has("autocmd")
  " Remove trailing whitespace on save for code files
  autocmd BufWritePre *.py,*.js,*.jsx,*.ts,*.tsx,*.go,*.rs,*.java,*.c,*.cpp,*.h call StripWhitespace()

  " File type associations
  autocmd BufNewFile,BufRead *.json setfiletype json
  autocmd BufNewFile,BufRead *.md setfiletype markdown
  autocmd BufNewFile,BufRead *.tsx setfiletype typescript.tsx
  autocmd BufNewFile,BufRead *.jsx setfiletype javascript.jsx
  autocmd BufNewFile,BufRead *.vue setfiletype vue
  autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
  autocmd BufNewFile,BufRead *.yml,*.yaml setfiletype yaml
  autocmd BufNewFile,BufRead *.toml setfiletype toml

  " Language-specific settings
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType make setlocal noexpandtab
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType markdown setlocal wrap linebreak textwidth=80

  " Return to last edit position when opening files
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

"==============================================================================
" Plugin Management (Optional - vim-plug)
"==============================================================================

" Uncomment and customize as needed
" call plug#begin('~/.vim/plugged')
"
" " Essential plugins
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-fugitive'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
"
" " Language support
" Plug 'sheerun/vim-polyglot'
" Plug 'dense-analysis/ale'
"
" " Themes
" Plug 'morhetz/gruvbox'
" Plug 'joshdick/onedark.vim'
"
" call plug#end()

"==============================================================================
" Development Shortcuts
"==============================================================================

" Quick edit .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Toggle spell check
nnoremap <leader>sp :setlocal spell!<CR>

" Quick save and run
nnoremap <leader>r :w<CR>:!%:p<CR>

" Insert current date/time
nnoremap <leader>dt "=strftime("%Y-%m-%d %H:%M:%S")<CR>P

"==============================================================================
" Performance & Compatibility
"==============================================================================

" Faster syntax highlighting for large files
set synmaxcol=300

" Reasonable redraw settings
set redrawtime=10000

" Better splitting
set splitbelow
set splitright

" Timeout settings
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=10

" Disable bells
set noerrorbells
set novisualbell
set t_vb=

"==============================================================================
" Modern Features
"==============================================================================

" Enable folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" Better grep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Better diff
if has('patch-8.1.0360')
  set diffopt+=internal,algorithm:patience
endif

"==============================================================================
" Final Settings
"==============================================================================

" Source local .vimrc if it exists
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" Welcome message
if has('autocmd')
  autocmd VimEnter * echo "Modern Vim configuration loaded!"
endif
