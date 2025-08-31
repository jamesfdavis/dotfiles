" Modern .gvimrc Configuration for 2025
" Optimized for software development

"==============================================================================
" Theme & Colors
"==============================================================================

" Set dark background first
set background=dark

" Try modern themes in order of preference
if exists('+termguicolors')
    set termguicolors
endif

" Theme priority: try modern themes first, fallback to classics
silent! colorscheme tokyonight-storm
if !exists('g:colors_name') || g:colors_name !=# 'tokyonight-storm'
    silent! colorscheme onedark
endif
if !exists('g:colors_name') || g:colors_name !=# 'onedark'
    silent! colorscheme gruvbox
endif
if !exists('g:colors_name') || g:colors_name !=# 'gruvbox'
    silent! colorscheme solarized
endif
" Final fallback to built-in theme
if !exists('g:colors_name')
    colorscheme desert
endif

"==============================================================================
" Font Configuration (macOS optimized)
"==============================================================================

" Font priority for different systems
if has('gui_macvim') || has('gui_vimr')
    " macOS - try modern coding fonts first
    set guifont=SF\ Mono:h14,Cascadia\ Code:h14,JetBrains\ Mono:h14,Fira\ Code:h14,Monaco:h14
elseif has('gui_gtk2') || has('gui_gtk3')
    " Linux
    set guifont=SF\ Mono\ 14,Cascadia\ Code\ 14,JetBrains\ Mono\ 14,Fira\ Code\ 14,DejaVu\ Sans\ Mono\ 14
elseif has('gui_win32')
    " Windows
    set guifont=Cascadia_Code:h14,Consolas:h14,Courier_New:h14
endif

"==============================================================================
" GUI Appearance
"==============================================================================

" Remove unnecessary GUI elements for cleaner interface
set guioptions-=T  " Remove toolbar
set guioptions-=r  " Remove right scrollbar
set guioptions-=R  " Remove right scrollbar when split
set guioptions-=l  " Remove left scrollbar
set guioptions-=L  " Remove left scrollbar when split
set guioptions-=m  " Remove menu bar
set guioptions-=e  " Use text-based tabs

" Keep useful elements
set guioptions+=c  " Use console dialogs instead of popup
set guioptions+=a  " Auto-select: copy to clipboard on selection

"==============================================================================
" Cursor Configuration
"==============================================================================

" Advanced cursor configuration for different modes
if has('gui_running')
    " Normal mode: block cursor, no blink
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0

    " Insert mode: thin vertical bar, blink
    set guicursor+=i:ver25-Cursor/lCursor-blinkon500-blinkoff500

    " Replace mode: horizontal bar
    set guicursor+=r-cr:hor20-Cursor/lCursor

    " Visual mode: block cursor with highlight
    set guicursor+=v:block-Cursor/lCursor-blinkon0

    " Command mode: underline
    set guicursor+=c:hor15-Cursor/lCursor-blinkon500-blinkoff500
endif

"==============================================================================
" Typography & Spacing
"==============================================================================

" Optimal line height for readability
set linespace=4

" Enable ligatures for coding fonts (if supported)
if has('gui_macvim')
    set macligatures
endif

"==============================================================================
" Window & Layout
"==============================================================================

" Set reasonable default window size
set lines=50
set columns=120

" Center the window on startup (macOS)
if has('gui_macvim')
    set fuoptions=maxvert,maxhorz
endif

" Smooth scrolling
if has('gui_running')
    set mousehide      " Hide mouse when typing
    set mousemodel=popup " Right-click popup menu
endif

"==============================================================================
" Performance & Rendering
"==============================================================================

" Improve rendering performance
set ttyfast
set lazyredraw

" Better redrawing
set redrawtime=10000

"==============================================================================
" Modern Features
"==============================================================================

" Enable transparency (if supported)
if has('gui_macvim')
    set transparency=5  " Slight transparency (0-100, 0=opaque)
endif

" Full-screen support
if has('gui_macvim')
    set fuoptions=maxvert,maxhorz,background:Normal
endif

"==============================================================================
" Context Menu & Interaction
"==============================================================================

" Customize right-click menu
if has('gui_running')
    " Remove some default items and add useful ones
    unmenu PopUp.How-to\ disable\ mouse
    unmenu PopUp.-1-

    " Add common development actions
    amenu PopUp.Open\ in\ Finder :!open %:h<CR>
    amenu PopUp.Copy\ File\ Path :let @+ = expand('%:p')<CR>
    amenu PopUp.-2- <Nop>
endif

"==============================================================================
" Font Size Controls
"==============================================================================

" Font size adjustment functions
function! AdjustFontSize(amount)
    let l:current_font = &guifont
    let l:size_pattern = '\v:h(\d+)'
    let l:current_size = str2nr(matchstr(l:current_font, l:size_pattern)[2:])
    let l:new_size = l:current_size + a:amount

    if l:new_size >= 8 && l:new_size <= 24
        let l:new_font = substitute(l:current_font, l:size_pattern, ':h' . l:new_size, '')
        let &guifont = l:new_font
        echo "Font size: " . l:new_size
    endif
endfunction

" Font size shortcuts (Cmd/Ctrl + Plus/Minus)
if has('gui_macvim')
    nnoremap <D-=> :call AdjustFontSize(1)<CR>
    nnoremap <D--> :call AdjustFontSize(-1)<CR>
    nnoremap <D-0> :set guifont=SF\ Mono:h14<CR>
else
    nnoremap <C-=> :call AdjustFontSize(1)<CR>
    nnoremap <C--> :call AdjustFontSize(-1)<CR>
    nnoremap <C-0> :set guifont=Cascadia\ Code:h14<CR>
endif

"==============================================================================
" Theme Switching
"==============================================================================

" Quick theme switching functions
function! ToggleTheme()
    if &background ==# 'dark'
        set background=light
        silent! colorscheme solarized
    else
        set background=dark
        silent! colorscheme tokyonight-storm
        if !exists('g:colors_name') || g:colors_name !=# 'tokyonight-storm'
            silent! colorscheme onedark
        endif
    endif
    echo "Theme: " . g:colors_name . " (" . &background . ")"
endfunction

" Theme toggle shortcut
if has('gui_macvim')
    nnoremap <D-t> :call ToggleTheme()<CR>
else
    nnoremap <F9> :call ToggleTheme()<CR>
endif

"==============================================================================
" Integration & Productivity
"==============================================================================

" Better clipboard integration
set clipboard=unnamed

" Improved search highlighting
set hlsearch
set incsearch

" Show relative line numbers in GUI
set number
set relativenumber

" Better tab display
set showtabline=2
set tabpagemax=20

"==============================================================================
" Conditional Settings
"==============================================================================

" MacVim specific optimizations
if has('gui_macvim')
    " Native fullscreen
    set fuoptions=maxvert,maxhorz,background:Normal

    " Better key handling
    set macmeta

    " Smooth scrolling
    set scroll=3
endif

" VimR (Neovim GUI) specific settings
if has('gui_vimr')
    set title
    set visualbell
endif

" Final message
if has('gui_running')
    echo "Modern gVim configuration loaded! Theme: " . (exists('g:colors_name') ? g:colors_name : 'default')
endif
