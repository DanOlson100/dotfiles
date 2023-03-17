--Dan's NeoVIM Lua Config File 
--
-- $Id: vimrc,v 1.12 2006/09/17 02:09:09 olson Exp $
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Plugin Setup
local HOME=os.getenv("HOME") or ""


--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Start Neopm Plugin Manager
Plug = require('neopm')

--Vim Plugins
Plug 'airblade/vim-gitgutter'                         -- Git Changes in Gutter
Plug 'ap/vim-css-color'                               -- CSS color highlighter
Plug 'chrisbra/vim-diff-enhanced'                     -- Use GIT diff algorithms
--Plug 'cohama/lexima.vim', { 'on': 'ToggleAutoClose'} -- Auto Close characters
Plug 'danolson100/molo'                               -- Molo Color Scheme
--Plug 'farmergreg/vim-lastplace'                     -- Let vim goto the last edit position except commit msgs.
--Plug 'frazrepo/vim-rainbow'                         -- Enhanced Rainbow Parens
--Plug 'godlygeek/tabular'                            -- For aligning text using :Tab /= or such
Plug 'inkarkat/vim-mark'                              -- Mark Words to Highlight
Plug 'inkarkat/vim-ingo-library'                      -- Dep Lib for vim-mark
--Plug 'jreybert/vimagit'                               -- Some git cmds added to Vim
--Plug 'kshenoy/vim-signature'                          -- Shows marks and move between them
Plug 'mbbill/undotree'                                -- Visualize Undo as a Tree
--Plug 'preservim/nerdtree'                             -- NerdTree File Browser
Plug 'preservim/vim-indent-guides'                    -- Indent Color guides
Plug 'rickhowe/diffchar.vim'                          -- Highlight only the Exact differences
--Plug 'sheerun/vim-polyglot'                           -- Collection of syntax highlights
--Plug 'tpope/vim-commentary'                           -- Add/Remove Comment Characters
Plug 'tpope/vim-eunuch'                               -- Various System commands
Plug 'tpope/vim-fugitive'                             -- Git in Vim
Plug 'tpope/vim-surround'                             -- Add/Remove Surrounding anything
Plug 'vim-scripts/IndexedSearch'                      -- Upgrade Search with status and location
--Plug 'Xuyuanp/nerdtree-git-plugin'                    -- NerdTree git status flags

--Neovim Plugins
Plug 'nvim-lua/plenary.nvim'                          -- Telescope Dependancy
Plug 'nvim-telescope/telescope.nvim'                  -- Telescope Fuzzy file finder
Plug 'nvim-treesitter/nvim-treesitter'                -- TreeSitter file parser for Syntax and Highlighting
Plug 'nvim-treesitter/nvim-treesitter-context'        -- TreeSitter Context plugin
Plug 'nvim-treesitter/playground'                     -- Tresitter playground 
Plug 'p00f/nvim-ts-rainbow'                           -- Rainbow parens
Plug 'ThePrimeagen/harpoon'                           -- File shortcut plugin

Plug.load()

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- General Options                              {{{
--vim.opt.filetype = "plugin"                         -- Load the filetype plugins
vim.opt.history = 100                                 -- How many lines of history to remember
vim.opt.cf = true                                     -- Enable error files and jumping
vim.opt.fileformats = "unix,dos,mac"                  -- Support these file systems
vim.opt.backup = false                                -- Don't Make Backup files
vim.opt.showcmd = true                                -- Show partial commands in the status line
vim.opt.modeline = false                              -- Security protection against trojan text files
vim.opt.title = true                                  -- Show filename in title bar

-- If on Windows Change the ffs
if vim.fn.has("gui_running") then
    if vim.fn.has("gui_win32") then
--        vim.opt.fileformats = "dos,unix,mac"
    end
end

-- Neovim uses a different format for undo files
--  Only Neovim uses this file
vim.opt.undodir  = HOME .. "/.config/nvim/undo-dir"
vim.opt.undofile = true                               -- Use Undo files to let undo work across exits

--}}} 
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Coloring                                     {{{
vim.opt.syntax = "on"                                 -- Turn on syntax highlighting
vim.opt.background = dark                             -- Try to use good colors

--if IsFile(HOME .. "/.config/nvim/plugged/molo/colors/molo.vim") then
--    vim.cmd("colorscheme molo")                     --Set the color scheme
--elseif IsFile(HOME .. "/vimfiles/colors/molo.vim") then
--    vim.cmd("colorscheme molo")                     --Set the color scheme for Win
--else
--    vim.cmd("colorscheme darkblue")                 --Set the color scheme
--end

-- Color Overrides
--vim.cmd("colorscheme darkblue")
--vim.cmd("colorscheme gruvbox")
vim.cmd("colorscheme molo")
--vim.cmd("colorscheme molokai")

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Vim UI                                       {{{
vim.opt.linespace = 0                                 -- Space it out
vim.opt.ruler = true                                  -- Show current position
vim.opt.number = true                                 -- Show line numbers, use cor for relative numbers
vim.opt.backspace = "indent,eol,start"                -- Make Backspace work
vim.opt.errorbells = false                            -- Don't make noise
vim.opt.visualbell = false                            -- Don't Blink cursor
--vim.opt.whichwrap:prepend {"<,>,h,l,[,]"}             -- Backspace and cursor key wrap
vim.opt.startofline = false                           -- Don't jump to the first char when paging
vim.opt.scrolloff = 10                                -- Keep cursor 10 lines from the top/bottom
vim.opt.laststatus = 2                                -- Always show the status line as two lines
vim.opt.ttyfast = true                                -- Setup redraw for faster terminals
vim.opt.lazyredraw = true                             -- Don't redraw the screen when running macros
vim.opt.splitbelow = true                             -- When splitting horizontal put the new window below
vim.opt.splitright = true                             -- When splitting vertical put the new window to the right

-- On Windows with Layout Scaling and High Resolutions
-- Change the font to a larger one
if vim.fn.has("gui_running") then
    if vim.fn.has("gui_win32") then
        vim.opt.guifont = "Consolas:h12"
    end
end

-- Use the Clipboard for P and yy
if vim.fn.has('clipboard') then
    if vim.fn.has('unnamedplus') then
        vim.opt.clipboard:prepend {"unnamedplus,unnamed"}
    else
        vim.opt.clipboard:prepend {"unnamed"}
    end
end

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Status Line                                  {{{
--
-- Get the git Branch w/ the Plugin vim-fugitive
-- But only do it an specific events
--if IsDir( HOME .. "/.config/nvim/plugged/vim-fugitive") then
    local au_id = vim.api.nvim_create_augroup("gitstatusline", {clear = true})
    vim.api.nvim_create_autocmd( { "BufEnter", "FocusGained", "BufWritePost" }, { pattern =  {"*"}, callback = function() vim.b.git_status = vim.fn['fugitive#Head']() end, group = "gitstatusline" } )
--else
--    vim.b.git_status = "" 
--end

-- These are also defined in the Molo Color Scheme
vim.cmd("hi User1 ctermbg=black  ctermfg=red        guibg=black  guifg=red")
vim.cmd("hi User2 ctermbg=red    ctermfg=DarkGreen  guibg=red    guifg=blue")
vim.cmd("hi User3 ctermbg=black  ctermfg=blue       guibg=black  guifg=blue")
vim.cmd("hi User4 ctermbg=black  ctermfg=magenta    guibg=black  guifg=magenta")
vim.cmd("hi User5 ctermbg=black  ctermfg=green      guibg=black  guifg=green")
vim.cmd("hi User6 ctermbg=black  ctermfg=yellow     guibg=black  guifg=yellow")

vim.cmd("set statusline=%1*[%3*%{toupper(mode())}%1*]")              --Show Mode
vim.cmd("set statusline+=[%4*%{get(b:,'git_status','')}%1*]")        --Show Git Branch
vim.cmd("set statusline+=[%5*%n%1*]")                                --Show Buffer #
vim.cmd("set statusline+=%F")                                        --Full Filename
vim.cmd("set statusline+=[%3*%M%1*")                                 --Modify Flag
vim.cmd("set statusline+=%2*%R%1*]")                                 --Read Only Flag
vim.cmd("set statusline+=%h")                                        --Help Flag
vim.cmd("set statusline+=%w")                                        --Show Preview if in Preview Window
vim.cmd("set statusline+=[%{&ff}]")                                  --File Format
vim.cmd("set statusline+=%y%3*")                                     --File Type
vim.cmd("set statusline+=%=")                                        --Right Align
vim.cmd("set statusline+=%1*[%L]")                                   --Total # of lines
vim.cmd("set statusline+=[%6*R%5*%5l%1*,%6*C%3*%5v%1*]")             --Current Line and Column #
vim.cmd("set statusline+=[%3p%%]")                                   --Percent through file

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Visual Cues                                  {{{
vim.opt.showmatch = true                              -- Show matching Brackets
vim.opt.matchtime = 5                                 -- 10th of seconds to blink matching brackets
vim.opt.hlsearch = true                               -- Highlight searched phrases
vim.opt.incsearch = true                              -- Highlight as you type searches
vim.opt.showmode = true                               -- Show vim's mode
vim.opt.ignorecase = true                             -- Ignore case when searching
vim.opt.smartcase = true                              -- Use case when searching using upper case chars

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Text Formatting/Layout                       {{{
--set formatoptions=tcrqn                             -- Format Option t=autowrap text, c=autowrap comments & auto insert after enter
--                                                    -- q=allow formatting with qq, n=reorganize numbered list
vim.opt.smartindent = True                            -- Turn on smart indenting
--filetype plugin indent on                           -- Turn on the plugin indent
vim.opt.tabstop = 4                                   -- Number of spaces to represent a Tab
vim.opt.shiftwidth = 4                                -- Number of spaces to use for each step of auto-indent
vim.opt.softtabstop = 4                               -- Remove 4 spaces with one backspace
vim.opt.expandtab = true                              -- Insert spaces instead of tabs
vim.opt.wrap = false                                  -- Don't wrap lines
vim.opt.shiftround = true                             -- Round indent to multiple of shiftwidth

--Change invisible characters: tab, end-of-line, spaces
--vim.opt.list = true
--vim.opt.lcs  = "tab:┠-,eol:¬,trail:·,extends:»,precedes:«"           --Show symbol for End of Line and Tabs

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Difference Options                           {{{

--See above in Coloring for color diff settings
-- Setup NeoVim Diff
vim.opt.diffopt:append { "internal,algorithm:patience" }
--let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Wild Menu                                    {{{
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore:append { ".hg,.git,.svn" }              -- Ignore version control files
vim.opt.wildignore:append { "*.jpeg,*.jpg,*.bmp,*.png" }   -- Ignore version control files
vim.opt.wildignore:append { "*.o,*.obj,*.exe,*.dll" }      -- Ignore compiled object files
vim.opt.wildignore:append { "*.sw?" }                      -- Ignore vim swap files
--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Folding                                      {{{
vim.opt.foldmethod = "marker"
vim.opt.foldlevelstart = 0

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Filetypes                                    {{{
--  Load before Keymaps as some depend on Filetypes

-- Add Helper lines for Git Commit Mesages
local au_id = vim.api.nvim_create_augroup("gitcommit", {clear = true})
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"gitcommit"}, callback = function() vim.opt.textwidth=72 vim.opt.colorcolumn="51,73" end, group = "gitcommit" } )

--if IsFile( HOME .. "/.vim/filetypes.vim") then
--    source HOME .. "/.vim/filetypes.vim"
--elseif IsFile( HOME .. "/vimfiles/filetypes.vim") then
--    source HOME .. "/vimfiles/filetypes.vim"
--end

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Key Mappings                                 {{{

-- Map Leader
vim.g.mapleader = ","

-- Map new goto start and end keys
vim.keymap.set( {"n", "v"}, "H", "0")
vim.keymap.set( {"n", "v"}, "L", "$")

-- Map ii to <Escape>
vim.keymap.set( {"i", "v"}, "ii", "<Esc>")

-- Map jj to <Escape>
vim.keymap.set( {"i", "v"}, "jj", "<Esc>")

-- Map vv to <Ctrl>v to use when terminal has Paste
vim.keymap.set("n", "vv", "<C-v>")

-- Use Space to toggle folds
vim.keymap.set( {"n", "v"}, "<Space>", "za")

-- Don't use the Arrow Keys
-- vim.keymap.set( "n", "<Up>",    "<NOP>")
-- vim.keymap.set( "n", "<Down>",  "<NOP>")
-- vim.keymap.set( "n", "<Left>",  "<NOP>")
-- vim.keymap.set( "n", "<Right>", "<NOP>")
-- vim.keymap.set( "i", "<Up>",    "<NOP>")
-- vim.keymap.set( "i", "<Down>",  "<NOP>")
-- vim.keymap.set( "i", "<Left>",  "<NOP>")
-- vim.keymap.set( "i", "<Right>", "<NOP>")

-- Move in Insert and Cmd (Dont Work)
vim.keymap.set( {"i", "c"}, "C-h>", "<Left>")
vim.keymap.set( {"i", "c"}, "C-j>", "<Down>")
vim.keymap.set( {"i", "c"}, "C-k>", "<Up>")
vim.keymap.set( {"i", "c"}, "C-l>", "<Right>")

-- Map Ctrl b or f to Page Down/Up
--  These are innate to vim
vim.keymap.set( "n", "<C-f>", "<PageDown>")
vim.keymap.set( "n", "<C-b>", "<PageUp>")

-- Buffer Commands
-- :b1 - move to buffer 1
vim.keymap.set( "n", "<leader>bn", "<Cmd>bnext<Cr>")
vim.keymap.set( "n", "<leader>bp", "<Cmd>bprevious<Cr>")

-- Correct Wq
vim.cmd( "cnoreabbrev Wq wq")

-- Correct Q
--cnoreabbrev Q q

-- Map ^u to Uppercase the current word
vim.keymap.set( {"n", "i"}, "<C-u>", "<Esc>mogUiw`oa")

-- Edit my Vim file
vim.keymap.set( "n", "<leader>ev", ":vsplit $MYVIMRC<Cr>")

-- Source my Vim file
vim.keymap.set( "n", "<leader>sv", ":source $MYVIMRC<Cr>")

-- Map ff over word to find and replace
--vim.keymap.set( "n", "ff", ":%s/<C-r>=expand(\"<cword>\")<CR>\>/")

-- Move a visual selection up/down
vim.keymap.set( "v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set( "v", "K", ":m '<-2<CR>gv=gv")

-- Move a single line up/down
vim.keymap.set( "n", "<leader>k", ":m .-2<CR>==")
vim.keymap.set( "n", "<leader>j", ":m .+1<CR>==")

-- Clear Search Highlights with Ctrl l
vim.keymap.set( "n", "<silent> <C-l>", "<Cmd>nohlsearch<CR><C-l>")

-- Yank from cursor to end of line excluding \n
vim.keymap.set( "n", "Y", "y$")

-- Join Lines but don't move cursor posiions
vim.keymap.set( "n", "<leader>J", "moJ`o")

-- Duplicate line at the end
vim.keymap.set( "n", "<leader>y", "yypkJ")

-- Shortcut split and vsplit
vim.keymap.set( "n", "<leader>s", "<Cmd>split<CR>")
vim.keymap.set( "n", "<leader>v", "<Cmd>vsplit<CR>")

-- Add Undo Break Points
vim.keymap.set( "i", ",", ",<C-g>u")
vim.keymap.set( "i", ".", ".<C-g>u")
vim.keymap.set( "i", "!", "!<C-g>u")
vim.keymap.set( "i", "?", "?<C-g>u")
vim.keymap.set( "i", ":", ":<C-g>u")
vim.keymap.set( "i", "(", "(<C-g>u")
vim.keymap.set( "i", "[", "[<C-g>u")
vim.keymap.set( "i", "{", "{<C-g>u")
vim.keymap.set( "i", ")", ")<C-g>u")
vim.keymap.set( "i", "]", "]<C-g>u")
vim.keymap.set( "i", "}", "}<C-g>u")

-- Various Commands (Don't Work)
--   col = Toggle list and show tab/EOL and other chars
--   con = Toggle line number display
--   cor = Toggle relative number display
--   cos = Toggle spell checking
--   cow = Toggle line wrapping
--   ccl = Toggle a diff color on the cursor row
--   ccc = Toggle a diff color on the cursor column
vim.keymap.set( "n", "<silent>col", "<Cmd>set list!<CR><Bar><Cmd>set list?<CR>")
vim.keymap.set( "n", "<silent>con", "<Cmd>set number!<CR><Bar><Cmd>set number?<CR>")
vim.keymap.set( "n", "<silent>cor", "<Cmd>set relativenumber!<CR><Bar><Cmd>set relativenumber?<CR>")
vim.keymap.set( "n", "<silent>cos", "<Cmd>set spell!<CR><Bar><Cmd>set spell?<CR>")
vim.keymap.set( "n", "<silent>cow", "<Cmd>set wrap!<CR><Bar><Cmd>set wrap?<CR>")
vim.keymap.set( "n", "<silent>ccl", "<Cmd>set cursorline!<CR><Bar><Cmd>set cursorline?<CR>")
vim.keymap.set( "n", "<silent>ccc", "<Cmd>set cursorcolumn!<CR><Bar><Cmd>set cursorcolumn?<CR>")

-- Start FZF
vim.keymap.set( "n", "<leader>fzf", "<Cmd>FZF<CR>")

-- Start/Stop Nerd Tree 
vim.keymap.set( "n", "<leader>nt", "<Cmd>NERDTreeToggle<CR>")

-- Toggle IndentGuides
vim.keymap.set( "n", "<leader>ig", "<Cmd>IndentGuidesToggle<CR>")

-- Toggle UndoTree
vim.keymap.set( "n", "<leader>ut", "<Cmd>UndotreeToggle<CR>")

-- Toggle TreeSitter-Context
vim.keymap.set( "n", "<leader>tsc", "<Cmd>TSContextToggle<CR>")

-- Add Comments with <leader>c , remove with <leader>z
local au_id = vim.api.nvim_create_augroup("comments", {clear = true})
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"vim"},                    callback = function() vim.keymap.set("n", "<leader>c", "mogI\"<ESC>`o") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"lua"},                    callback = function() vim.keymap.set("n", "<leader>c", "mogI--<ESC>`o") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"sh","bash","csh","perl"}, callback = function() vim.keymap.set("n", "<leader>c", "mogI#<ESC>`o")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"yaml","python"},          callback = function() vim.keymap.set("n", "<leader>c", "mogI#<ESC>`o")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"cpp","c"},                callback = function() vim.keymap.set("n", "<leader>c", "mogI//<ESC>`o") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"skill"},                  callback = function() vim.keymap.set("n", "<leader>c", "mogI;<ESC>`o")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"spice"},                  callback = function() vim.keymap.set("n", "<leader>c", "mogI*<ESC>`o")  end, group = "comments" } )

vim.api.nvim_create_autocmd( "FileType", { pattern =  {"vim"},                    callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/"//<CR><CMD>nohlsearch<CR>`o')   end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"lua"},                    callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/--//<CR><CMD>nohlsearch<CR>`o')   end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"sh","bash","csh","perl"}, callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`o')    end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"yaml","python"},          callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`o')    end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"cpp","c"},                callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/////<CR><CMD>nohlsearch<CR>`o')     end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"skill"},                  callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/;//<CR><CMD>nohlsearch<CR>`o')    end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"spice"},                  callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/*//<CR><CMD>nohlsearch<CR>`o')    end, group = "comments" } )

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Setup Plugins                                {{{

-- DiffChar Settings
vim.g.DiffUnit = "Char"
--vim.g.DiffUnit = "Word"

-- Telescope Setup
vim.keymap.set( {"n"}, "<leader>ff", "<Cmd>Telescope find_files<Cr>")
vim.keymap.set( {"n"}, "<leader>fg", "<Cmd>Telescope live_grep<Cr>")
vim.keymap.set( {"n"}, "<leader>fb", "<Cmd>Telescope buffers<Cr>")
vim.keymap.set( {"n"}, "<leader>fh", "<Cmd>Telescope help_tags<Cr>")

-- Tree sitter Setup
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "help", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)

        -- list of language that will be disabled
        disable = { "c", "rust" },

        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
    },

    -- Rainbow Markers Setup
    rainbox = {
        enable = true,
        -- disable = { "cpp" },  -- Table of lang you want disabled
        extended_mode = true,    -- Also highlight non-bracket delimiters like html tags, boolean or tables
        max_file_lines = nil,    -- Do not enable for files with more than n lines, 
        -- colors = {},          -- Table of hex strings
        -- termcolors = {}       == Table of color name strings
   }
}

-- TreeSitter Context Setup
require'treesitter-context'.setup {
    enable = True,            -- Enable this Plugin
    max_lines = 0,            -- How many lines the window should span. Values <=0 mean no limit.
    min_window_height = 0,    -- Minimum editory height to enable context. Values <=0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
    trim_scope = 'outer',     -- Which context lines to discard if 'max_lines' is exceeded, 'inner' or 'outer'
    mode = 'cursor',         -- Line used to calculate context, 'cursor' or 'topline'
    separator = nil,          -- 
    zindex = 20,              -- The Z-index of the context window
}


--}}}

