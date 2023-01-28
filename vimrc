"Dan's VIM Config File 
"
" $Id: vimrc,v 1.12 2006/09/17 02:09:09 olson Exp $
""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins                                      {{{
"  Commands
"    PlugInstall - Install new plug-ins
"    PlugUpdate  - Update installed plug-ins
"    PlugUpgrade - Upgrade the plugged Plug-in
"    PlugStatus  - Fetch the status of the Plug-ins
if !empty(glob("~/.vim/plugged")) || !empty(glob("~/vimfiles/plugged"))
    call plug#begin('~/.vim/plugged')
    Plug 'airblade/vim-gitgutter'                       "Git Changes in Gutter
    Plug 'ap/vim-css-color'                             "CSS color highlighter
    Plug 'chrisbra/vim-diff-enhanced'                   "Use GIT diff algorithms
    Plug 'cohama/lexima.vim', { 'on': 'AUTOClose' }     "Auto Close characters
    Plug 'danolson100/molo'                             "Molo Color Scheme
    Plug 'frazrepo/vim-rainbow'                         "Enhanced Rainbow Parens
    Plug 'godlygeek/tabular'                            "For aligning text using :Tab /= or such
    Plug 'inkarkat/vim-mark'                            "Mark Words to Highlight
    Plug 'inkarkat/vim-ingo-library'                    "Dep Lib for vim-mark
    Plug 'jreybert/vimagit'                             "Some git cmds added to Vim
    Plug 'junegunn/fzf.vim'                             "FZF Vim integration with common Cmd maps
    Plug 'kshenoy/vim-signature'                        "Shows marks and move between them
    Plug 'nathanaelkane/vim-indent-guides'              "Indent Color guides
    Plug 'neoclide/coc.nvim', { 'branch': 'release', 'on': 'ToggleCoC' }
    "Plug 'neoclide/coc.nvim', { 'branch': 'release' }   "Code Completion
    Plug 'rafi/awesome-vim-colorschemes'                "Collection of Vim Color Schemes
"    Plug 'rickhowe/diffchar.vim', { 'frozen': 1 }       "Highlight only the Exact differences
    Plug 'rickhowe/diffchar.vim'                        "Highlight only the Exact differences
    Plug 'scrooloose/nerdtree', { 'on': 'ToggleNerdTree' }
    Plug 'sheerun/vim-polyglot'                         "Collection of syntax highlights
    Plug 'tpope/vim-commentary'                         "Add/Remove Comment Characters
    Plug 'tpope/vim-eunuch'                             "Various System commands
    Plug 'tpope/vim-fugitive'                           "Git in Vim
    Plug 'tpope/vim-surround'                           "Add/Remove Surrounding anythino
    Plug 'vim-scripts/IndexedSearch'                    "Upgrade Search with status and location
    call plug#end()
endif
"  }}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" General Options                              {{{
filetype on                                 "Detect the type of File
filetype plugin on                          "Load filetype plugins
set history=1000                            "How may lines of History to remember
set cf                                      "Enable error files and jumping
set ffs=unix,dos,mac                        "Support these filesystems
set nobackup                                "Don't Make Backup files
set showcmd                                 "Show partial commands in the status line
set nomodeline                              "Security protection against trojaned text files
set title                                   "Show filename in title bar 

" If on Windows Change the ffs
if has("gui_running")
    if has("gui_win32")
        set ffs=dos,unix,mac
    endif
endif

" Neovim uses a different format for undo files
if has('nvim')
    set undodir=~/.config/nvim/undo-dir
else
    set undodir=~/.vim/undo-dir             "Set the Undo Directory
endif
set undofile                                "Use Undo files to let undo work across exist

" }}} 
""""""""""""""""""""""""""""""""""""""""""""""""""
" Coloring                                     {{{
syntax on                                         "Turn on syntax highlighting
set background=dark                               "Try to use good colors

if !empty(glob("~/.vim/plugged/molo/colors/molo.vim"))
    colorscheme molo                              "Set the color scheme
elseif !empty(glob("~/vimfiles/colors/molo.vim"))
    colorscheme molo                              "Set the color scheme for Win
else
    colorscheme darkblue                          "Set the color scheme
endif

" Color Overrides
"colorscheme darkblue 
"colorscheme gruvbox 
"colorscheme molo
"colorscheme molokai

" }}} 
""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI                                       {{{
set linespace=0                             "Space it out
set ruler                                   "Show current position
set number                                  "Show line numbers, use cor for relative numbers
set backspace=indent,eol,start              "Make Backspace work
"set t_kD=                                "Fix Delete Key
set noerrorbells                            "Don't make noise
set novisualbell                            "Don't Blink cursor
set whichwrap+=<,>,h,l,[,]                  "Backspace and cursor key wrap
set nostartofline                           "Don't jump to first char when paging
set scrolloff=10                            "Keep cursor 10 lines from the top/bottom 
set laststatus=2                            "Always show the status line as two lines
set ttyfast                                 "Setup redraw for faster terminals
set lazyredraw                              "Don't redraw screen when running macros
set splitbelow                              "When splitting horizontal put the new window below
set splitright                              "When splitting vertical put the new window to the right

" On Windows with Layout Scaling and High Resolutions
" Change the font to a larger one
if has("gui_running")
    if has("gui_win32")
        set guifont=Consolas:h12
    endif
endif

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" Status Line                                  {{{

" Get the git Branch w/ the Plugin vim-fugitive
" But only do it an specific events
if !empty(glob("~/.vim/plugged/vim-fugitive/"))
    augroup gitstatusline
        au!
        autocmd BufEnter,FocusGained,BufWritePost *  let b:git_status = fugitive#Head()
    augroup END
else
    let b:git_status = ""
endif

hi User1 ctermbg=black  ctermfg=red        guibg=black  guifg=red
hi User2 ctermbg=red    ctermfg=DarkGreen  guibg=red    guifg=blue
hi User3 ctermbg=black  ctermfg=blue       guibg=black  guifg=blue
hi User4 ctermbg=black  ctermfg=magenta    guibg=black  guifg=magenta
hi User5 ctermbg=black  ctermfg=green      guibg=black  guifg=green
hi User6 ctermbg=black  ctermfg=yellow     guibg=black  guifg=yellow

set statusline=%1*[%3*%{toupper(mode())}%1*]  "Show Mode
set statusline+=[%4*%{get(b:,'git_status','')}%1*]       "Show Git Branch
set statusline+=[%5*%n%1*]                    "Show Buffer #
set statusline+=%F                            "Full Filename
set statusline+=[%3*%M%1*                     "Modify Flag
set statusline+=%2*%R%1*]                     "Read Only Flag
set statusline+=%h                            "Help Flag
set statusline+=%w                            "Show Preview if in Preview Window
set statusline+=[%{&ff}]                      "File Format
set statusline+=%y%3*                         "File Type
set statusline+=\ %=                          "Right Align
set statusline+=%1*[%L]                       "Total # of lines 
set statusline+=[%6*R%5*%5l%1*,%6*C%3*%5v%1*] "Current Line and Column #
set statusline+=[%3p%%]                       "Percent through file

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues                                  {{{
set showmatch                               "Show matching Brackets
set matchtime=5                             "10th of seconds to blink matching brackets
set hlsearch                                "Highlight searched phrases
set incsearch                               "Highligh as you type searches
set showmode                                "Show vim's mode
set ignorecase                              "Ignore case when searching
set smartcase                               "Use case when searching using upper case chars

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout                       {{{
set formatoptions=tcrqn                     "Format Option t=autowrap text, c=autowrap comments & auto insert after enter
                                            "q=allow formatting with qq, n=reorganize numbered list
set smartindent                              "Turn on smart indenting
filetype plugin indent on                   "Turn on the plugin indent
set tabstop=4                               "Number of spaces to represent a Tab
set shiftwidth=4                            "Number of spaces to use for each step of auto-indent
set softtabstop=4                           "Remove 4 spaces with one backspace
set expandtab                               "Insert spaces instead of tabs
set nowrap                                  "Don't wrap lines 
set shiftround                              "Round indent to multiple of shiftwidth

"Change invisible characters: tab, end-of-line, spaces
"try 
"    " tab=^VU2520- ecl=^V172  trail=^V183  extends=^V187  precedes=^V171
"    set list lcs=tab:┠-,eol:¬,trail:·,extends:»,precedes:«           "Show symbol for End of Line and Tabs
"catch /^Vim\%((\a\+)\)\=:E474/
"    " ASCI version Dont set a lcs
"    set list lcs=tab:
"endtry

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""
" Difference Opions                           {{{

"See above in Coloring for color diff setings

" Normal Vim got xdiff lib
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
else
    if !empty(glob("~/.vim/plugged/vim-diff-enhanced/"))
        let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
    endif
endif

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""
" Wild Menu                                   {{{
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn               "Ignore version control files
set wildignore+=*.jpeg,*.jpg,*.bmp,*.png    "Ignore binary images
set wildignore+=*.o,*.obj,*.exe,*.dll       "Ignore compiled object files
set wildignore+=*.sw?                       "Ignore vim swap files
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""
" Folding                                     {{{
set foldmethod=marker
set foldlevelstart=0

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""
" FZF Settings                                {{{

" Add the path to FZF
if !empty(glob("~/.fzf/"))
    set rtp+=~/.fzf
endif

" Use the Vim Color Scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings                                {{{

" Map Leader
let mapleader=","

"Map new goto start and end keys
noremap  H 0
noremap  L $
vnoremap L g_

"Map ii to <Escape>
"inoremap ii <Esc>
"vnoremap ii <Esc>

"Map jj to <Escape>
inoremap jj <Esc>
vnoremap jj <Esc>

" Map vv to <Ctrl>v to use besides Past
noremap vv <C-v>

" Use Space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Don't use the Arrow Keys
"noremap  <Up>    <NOP>
"noremap  <Down>  <NOP>
"noremap  <Left>  <NOP>
"noremap  <Right> <NOP>
"inoremap <Up>    <NOP>
"inoremap <Down>  <NOP>
"inoremap <Left>  <NOP>
"inoremap <Right> <NOP>

"Move in Insert
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"Move in Cmd
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Map J or K to Page Down/Up
nnoremap J <PageDown>
nnoremap K <PageUp>

" Correct Wq
cnoreabbrev Wq wq

" Correct Q
cnoreabbrev Q q

"Map ^u to Uppercase the current word
inoremap  <C-u> <Esc>mogUiw`oa

"Edit my Vim file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"Source my Vim file
nnoremap <leader>sv :source $MYVIMRC<cr>

" Map ff over word to find and replace
nnoremap ff :%s/\<<C-r>=expand("<cword>")<CR>\>/

" Move a visual selecion 
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move a single line up/down
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" Clear Search Highlights with Ctrl l
nnoremap <silent> <C-l> <Cmd>nohlsearch<CR><C-l>

" Yank from cursor to end of line
nnoremap Y y$

" Join Lines but don't move cursor posiions
nnoremap <leader>J moJ`o

" Start FZF
nnoremap <C-p> :FZF<CR>

" Add Undo Break Poins
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u
inoremap ( (<C-g>u
inoremap [ [<C-g>u
inoremap { {<C-g>u
inoremap ) )<C-g>u
inoremap ] ]<C-g>u
inoremap } }<C-g>u

" Various Commands
nnoremap <silent> col <Cmd>set list!<CR><Bar><Cmd>set list?<CR>
nnoremap <silent> con <Cmd>set number!<CR><Bar><Cmd>set number?<CR>
nnoremap <silent> cor <Cmd>set relativenumber!<CR><Bar><Cmd>set relativenumber?<CR>
nnoremap <silent> cos <Cmd>set spell!<CR><Bar><Cmd>set spell?<CR>
nnoremap <silent> cow <Cmd>set wrap!<CR><Bar><Cmd>set wrap?<CR>
nnoremap <silent> ccl <Cmd>set cursorline!<CR><Bar><Cmd>set cursorline?<CR>
nnoremap <silent> ccc <Cmd>set cursorcolumn!<CR><Bar><Cmd>set cursorcolumn?<CR>

" Remove augroups on reload
augroup comments
    au!

    "Add a comment shortcut based on filetype
    au FileType vim                   nnoremap <leader>c mogI"<ESC>`o
    au FileType sh,bash,csh,perl      nnoremap <leader>c mogI#<ESC>`o
    au FileType yaml,python           nnoremap <leader>c mogI#<ESC>`o
    au FileType c,cpp                 nnoremap <leader>c mogI//<ESC>`o
    au FileType skill                 nnoremap <leader>c mogI;<ESC>`o

    "Remove a comment shortcut based on filetype
    au FileType vim                   nnoremap <leader>z mo<CMD>s/"//<CR><CMD>nohlsearch<CR>`o
    au FileType sh,bash,csh,perl      nnoremap <leader>z mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`o
    au FileType yaml,python           nnoremap <leader>z mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`o
    au FileType c,cpp                 nnoremap <leader>z mo<CMD>s/\/\///<CR><CMD>nohlsearch<CR>`o
    au FileType skill                 nnoremap <leader>z mo<CMD>s/;//<CR><CMD>nohlsearch<CR>`o

augroup END

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes                                   {{{

if !empty(glob("~/.vim/filetypes.vim"))
    source ~/.vim/filetypes.vim
elseif !empty(glob("~/vimfiles/fileypes.vim"))
    source ~/vimfiles/filetypes.vim
endif

" }}}

