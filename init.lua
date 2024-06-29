-- Dan's NeoVim Config
--
-- $Id: vimrc,v 1.12 2006/09/17 02:09:09 olson Exp $
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Plugin Setup                                 {{{
vim.loader.enable()

local HOME=os.getenv("HOME") or ""

-- Check File/Dir Exists
local function exists(name)
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end

-- Check if File
local function IsFile(name)
    if type(name)~="string" then return false end
    if not exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end

-- Check if Dir
local function IsDir(name)
    return (exists(name) and not IsFile(name))
end

--  Set <leader>, Must happen before plugins are loaded, otherwise wrong leader will be used
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Diable NetRW for Nvim-Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Large File Support
local bigfile = 1024*1024
local aug = vim.api.nvim_create_augroup("buf_large", {clear = true})
vim.api.nvim_create_autocmd({"BufReadPre"}, {
    callback = function()
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > bigfile) then
            vim.b.large_bud = true
            --vim.opt.syntax = "off"
            --vim.cmd("IlluminatePauseBuf")
            --vim.cmd("IndentBlanklineDisable")
            vim.cmd("ContextDisable")
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.cmd("TSBufDisable autotag")
        else
            vim.b.large_buf = false
        end
    end,
    group = aug,
    pattern = "*",
})

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Plugin Instalation                           {{{

-- Install Lazy Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy and Install Other Plugins
require('lazy').setup({
-- Basic Vim Plugins
    'ap/vim-css-color',                               -- CSS color highlighter
    'chrisbra/vim-diff-enhanced',                     -- Use GIT diff algorithms
    'farmergreg/vim-lastplace',                       -- Let vim goto the last edit position except commit msgs.
    'godlygeek/tabular',                              -- For aligning text using :Tab /= or such
    'jreybert/vimagit',                               -- Some git cmds added to Vim
    'kshenoy/vim-signature',                          -- Shows marks and move between them
    'mbbill/undotree',                                -- Visualize Undo as a Tree
    'preservim/vim-indent-guides',                    -- Indent Color guides
    'rickhowe/diffchar.vim',                          -- Highlight only the Exact differences
    'sheerun/vim-polyglot',                           -- Various Syntax Files
    'tpope/vim-eunuch',                               -- Various System commands
    'tpope/vim-fugitive',                             -- Git in Vim
    'tpope/vim-surround',                             -- Add/Remove Surrounding anything
    'vim-scripts/IndexedSearch',                      -- Upgrade Search with status and location
    'wellle/context.vim',                             -- Show only context funtion/loops/if - Similar to TreeSitter-Context for Nvim

-- NeoVim Plugins with Configs
    -- LSP Plugin
    { 'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',                -- LSP Installer Plugin
            'williamboman/mason-lspconfig.nvim',      -- LSP Config Plugin
            { 'j-hui/fidget.nvim', opts = { }, tag = 'legacy' },       -- UI for LSP Plugins
           'folke/neodev.nvim',                      -- LSP Setup Plugin
        },
    },

    -- Git Signs in the Gutter w/ more features than gitgutter
    { 'lewis6991/gitsigns.nvim'},

    -- LSP Completion Plugins (Type Ahead)
    { 'hrsh7th/nvim-cmp',
        dependencies = {
	        'hrsh7th/cmp-nvim-lsp',                   -- LSP Source Plugin
	        -- 'L3MON4D3/LuaSnip',                       -- LSP Snip
	        'saadparwaiz1/cmp_luasnip'                -- LSP Completion Source for Snip
	    },
    },

    -- LuaSnips Dep of nvim-cmp
    -- Keep seperate from nvim-cmp to execute the build for jsregexp
    {   "L3MON4D3/LuaSnip",
        build = "make install_jsregexp"
    },

    -- Popup for key completion
    -- { 'folke/which-key.nvim', opts = {} },

    -- Personal Color Scheme 
    {   'danolson100/molo',
        priority = 1001,
        config = function()
            vim.cmd.colorscheme 'molo'
        end,
    },

    -- Lua Rocks Plugin
--    {   "vhyrro/luarocks.nvim",
--        priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
--        config = true,
--    },

    -- Mark Words to Highlight (Works in Vim)
    {   'inkarkat/vim-mark',
        priority = 999,                                 -- Needed for priority issue with * 
        dependencies = {
            'inkarkat/vim-ingo-library',                -- Dep Lib for vim-mark
        },
    },

    -- Indent Guides
--    { 'lukas-reineke/indent-blankline.nvim',
--        opts = {
--            char = '┊',
--            show_trailing_blankline_indent = false,
--        },
--    },

    -- NVim Directory Browser
    { 'nvim-tree/nvim-tree.lua' },

    -- Telescope Fuzzy Finder and dependencies
    { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    -- Tree Sitter Plugin and dependencies for language parsing
    { 'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        --config = function()
        --    pcall(require('nvim-treesitter.install').update { with_sync = true })
        --end,
    },

    -- Rainbow Parens
    { 'HiPhish/rainbow-delimiters.nvim'},

    -- Buffer Tabs at the top
    { 'akinsho/bufferline.nvim'},

    -- Harpoon for Project Navigation  
    { 'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

}, {
    -- Don't Install on Startup
    install = {
        missing = false,
    },
})

---}}}
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

-- Neovim uses a different format for undo files
--  Only Neovim uses this file
vim.opt.undodir  = vim.fn.stdpath('data') .. "/undo-dir"   -- Set Undo file storage location
vim.opt.undofile = true                               -- Use Undo files to let undo work across exits

--}}} 
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Coloring                                     {{{
vim.opt.syntax = "on"                                 -- Turn on syntax highlighting
vim.opt.background = "dark"                           -- Try to use good colors
-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true                          -- Turn on True Colors if the Term support it

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
vim.opt.mouse = 'a'                                   -- Enable Mouse mode
vim.opt.completeopt = 'menuone,noselect'              -- Show completion options in a menu

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
vim.b.git_status = ""
if ( vim.g.loaded_fugitive) then
    vim.api.nvim_create_augroup("gitstatusline", {clear = true})
    vim.api.nvim_create_autocmd( { "BufEnter", "FocusGained", "BufWritePost" }, {  callback = function() vim.b.git_status = vim.fn['fugitive#Head']() end, group = "gitstatusline" } )
end

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
vim.opt.smartindent = true                            -- Turn on smart indenting
--filetype plugin indent on                           -- Turn on the plugin indent
vim.opt.tabstop = 4                                   -- Number of spaces to represent a Tab
vim.opt.shiftwidth = 4                                -- Number of spaces to use for each step of auto-indent
vim.opt.softtabstop = 4                               -- Remove 4 spaces with one backspace
vim.opt.expandtab = true                              -- Insert spaces instead of tabs
vim.opt.wrap = false                                  -- Don't wrap lines
vim.opt.shiftround = true                             -- Round indent to multiple of shiftwidth
vim.opt.breakindent = true                            -- Indent w/ line cont characters


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
vim.opt.wildignore:append { "*.jpeg,*.jpg,*.bmp,*.png" }   -- Ignore binary picture files
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
vim.api.nvim_create_augroup("gitcommit", {clear = true})
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"gitcommit"}, callback = function() vim.opt.textwidth=72 vim.opt.colorcolumn="51,73" end, group = "gitcommit" } )

if IsFile( HOME .. "/.vim/filetypes.vim") then
    vim.cmd( "source" .. HOME .. "/.vim/filetypes.vim")
elseif IsFile( HOME .. "/vimfiles/filetypes.vim") then
    vim.cmd( "source" .. HOME .. "/vimfiles/filetypes.vim")
end
--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Key Mappings                                 {{{

-- Map new goto start and end keys
vim.keymap.set( {"n", "v"}, "H", "0")
vim.keymap.set( {"n", "v"}, "L", "$")

-- Map ii to <Escape>
vim.keymap.set( {"n", "i", "v"}, "ii", "<Esc>")

-- Map jj to <Escape>
--vim.keymap.set( {"n", "i", "v"}, "jj", "<Esc>")

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

-- Switch Splits
--vim.keymap.set( "n", "ww", "<C-w><C-w>")
vim.keymap.set( "n", "qq", "<C-w><C-w>")

-- Buffer Commands
-- :b1 - move to buffer 1
vim.keymap.set( "n", "<leader>bn", "<Cmd>bnext<Cr>")
vim.keymap.set( "n", "<leader>bp", "<Cmd>bprevious<Cr>")

-- Correct Wq
vim.cmd( "cnoreabbrev Wq wq")

-- Correct Q
--cnoreabbrev Q q

-- Map Ctrl-u to Uppercase the current word
vim.keymap.set( {"n"}, "<C-u>", "gUaw")

-- Map Ctrl-l to Lowercase the current word
vim.keymap.set( {"n"}, "<C-l>", "guaw")

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

-- Clear Search highlights with Ctrl s
vim.keymap.set( "n", "<C-s>", function() vim.cmd("noh") end )

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

-- Various Commands
--   Neovim doesn't have <silent>
--   col = Toggle list and show tab/EOL and other chars
--   con = Toggle line number display
--   cor = Toggle relative number display
--   cos = Toggle spell checking
--   cow = Toggle line wrapping
--   ccl = Toggle a diff color on the cursor row
--   ccc = Toggle a diff color on the cursor column
vim.keymap.set( "n", "col", function() vim.cmd("set list!") end )
vim.keymap.set( "n", "con", function() vim.cmd("set number!") end )
vim.keymap.set( "n", "cor", function() vim.cmd("set relativenumber!") end )
vim.keymap.set( "n", "cos", function() vim.cmd("set spell!") end )
vim.keymap.set( "n", "cow", function() vim.cmd("set wrap!") end )
vim.keymap.set( "n", "ccl", function() vim.cmd("set cursorline!") end )
vim.keymap.set( "n", "ccc", function() vim.cmd("set cursorcolumn!") end )

-- Toggle IndentGuides
vim.keymap.set( "n", "<leader>ig", "<Cmd>IndentGuidesToggle<CR>")

-- Toggle UndoTree
vim.keymap.set( "n", "<leader>ut", "<Cmd>UndotreeToggle<CR>")

-- Toggle NvimTree
vim.keymap.set( "n", "<leader>nt", "<Cmd>NvimTreeToggle<CR>")

-- Toggle Context
vim.keymap.set( "n", "<leader>ct", "<Cmd>ContextToggle<CR>")

-- Harpoon Keybindings
vim.keymap.set( "n", "<leader>mf", function() require('harpoon.mark').add_file() end,         { desc = 'Harpoon Add File'} )
vim.keymap.set( "n", "<leader>ff", function() require('harpoon.ui').toggle_quick_menu() end,  { desc = 'Harpoon Menu'} )
vim.keymap.set( "n", "<leader>nf", function() require('harpoon.ui').nav_next() end,           { desc = 'Harpoon Next File'} )
vim.keymap.set( "n", "<leader>pf", function() require('harpoon.ui').nav_prev() end,           { desc = 'Harpoon Prev File'} )

-- Add Comments with <leader>c , remove with <leader>z
vim.api.nvim_create_augroup( "comments", { clear = true})
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"vim"},                    callback = function() vim.keymap.set("n", "<leader>c", "mogI\"<ESC>`odmo") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"lua"},                    callback = function() vim.keymap.set("n", "<leader>c", "mogI--<ESC>`odmo") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"sh","bash","csh","perl"}, callback = function() vim.keymap.set("n", "<leader>c", "mogI#<ESC>`odmo")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"yaml","python", "conf"},  callback = function() vim.keymap.set("n", "<leader>c", "mogI#<ESC>`odmo")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"cpp","c"},                callback = function() vim.keymap.set("n", "<leader>c", "mogI//<ESC>`odmo") end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"skill"},                  callback = function() vim.keymap.set("n", "<leader>c", "mogI;<ESC>`odmo")  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"spice"},                  callback = function() vim.keymap.set("n", "<leader>c", "mogI*<ESC>`odmo")  end, group = "comments" } )

vim.api.nvim_create_autocmd( "FileType", { pattern =  {"vim"},                    callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/"//<CR><CMD>nohlsearch<CR>`odmo')  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"lua"},                    callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/--//<CR><CMD>nohlsearch<CR>`odmo') end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"sh","bash","csh","perl"}, callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`odmo')  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"yaml","python"},          callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/#//<CR><CMD>nohlsearch<CR>`odmo')  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"cpp","c"},                callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/////<CR><CMD>nohlsearch<CR>`odmo') end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"skill"},                  callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/;//<CR><CMD>nohlsearch<CR>`odmo')  end, group = "comments" } )
vim.api.nvim_create_autocmd( "FileType", { pattern =  {"spice"},                  callback = function() vim.keymap.set("n", "<leader>z", 'mo<CMD>s/*//<CR><CMD>nohlsearch<CR>`odmo')  end, group = "comments" } )

--}}}
--"""""""""""""""""""""""""""""""""""""""""""""""""
-- Setup Plugins                                {{{

-- Disable some providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- DiffChar Settings
vim.g.DiffUnit = "Char"
--vim.g.DiffUnit = "Word"

-- Disable LuaRocks
--opts.rocks.hererocks = false

-- Configure Telescope
local ts_status, ts_plug = pcall(require, 'telescope')
if ts_status then
    ts_plug.setup {
        defaults = {
            mappings = {
                i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                },
            },
        },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- Setup Keymaps for Telescope
    vim.keymap.set('n', '<leader>sf',      require('telescope.builtin').find_files,  { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh',      require('telescope.builtin').help_tags,   { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw',      require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg',      require('telescope.builtin').live_grep,   { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd',      require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>?',       require('telescope.builtin').oldfiles,    { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,     { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })
end

-- Configure Treesitter
local tsit_status, tsit_plug = pcall(require, 'nvim-treesitter.configs')
if tsit_status then
    tsit_plug.setup {
        -- Add languages to be installed here that you want installed for treesitter
        --ensure_installed = { 'bash', 'c', 'cpp', 'go', 'lua', 'perl', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        --highlight = { enable = true, disable = function(){ return vim.b.large_buf } },
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
        },
    }
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,  { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,  { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Setup the LSP
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename,                                         '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action,                                    '[C]ode [A]ction')
    nmap('gd',         vim.lsp.buf.definition,                                     '[G]oto [D]efinition')
    nmap('gr',         require('telescope.builtin').lsp_references,                '[G]oto [R]eferences')
    nmap('gI',         vim.lsp.buf.implementation,                                 '[G]oto [I]mplementation')
    nmap('<leader>D',  vim.lsp.buf.type_definition,                                'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols,          '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K',          vim.lsp.buf.hover,                                          'Hover Documentation')
    nmap('<C-k>',      vim.lsp.buf.signature_help,                                 'Signature Documentation')
    nmap('gD',         vim.lsp.buf.declaration,                                    '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder,                           '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder,                        '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- Add default global "vim" otherwise you get warnings in all vim configs
            diagnostics = {
                globals = { "vim" }
            },
        },
    },
}

-- Setup Neovim Lua Configuration
local nd_status, nd_plug = pcall(require, 'neodev')
if nd_status then
    nd_plug.setup()
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cnl_status, cnl_plug = pcall(require, 'cmp_nvim_list')
if cnl_status then
    capabilities = cnl_plug.default_capabilities(capabilities)
end

-- Setup mason so it can manage external tooling
local mason_status, mason_plug = pcall(require, 'mason')
if mason_status then
    mason_plug.setup()
end

-- Ensure the servers above are installed
local mlsp_status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mlsp_status then
    mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
        function(server_name)
            require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
            }
        end,
    }
end

-- nvim-cmp setup
local cmp_status, cmp = pcall(require, 'cmp')
if cmp_status then

    local ls_status, luasnip = pcall(require, 'luasnip')
    if ls_status then
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        }
    end
end

-- Setup Harpoon
local har_status, har_plug = pcall(require, 'harpoon')
if har_status then
    har_plug.setup {
        global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
        },
    }
end

-- Setup NVim-Tree
local nt_status, nt_plug = pcall(require, 'nvim-tree')
if nt_status then
    nt_plug.setup({
        sort_by  = "case_sensitive",
        renderer = { group_empty = true, },
        filters  = { dotfiles = false, },
    })
end

-- Setup Buffer Tabs at the top
local bl_status, bl_plug = pcall(require, 'bufferline')
if bl_status then
    bl_plug.setup{}
end

-- Setup Rainbow delimiters
local rain_status, rain_plug = pcall(require, 'rainbow-delimiters')
if rain_status then
    vim.g.rainbow_delimiters = {
        strategy = {
            [''] = rain_plug.strategy['global'],
            commonlisp = rain_plug.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        highlight = {
           'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
    }
end

-- Setup gitsigns for GitSigns functions
local gs_status, gs_plug = pcall(require, 'gitsigns')
if gs_status then
    gs_plug.setup {
        signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '-' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signcolumn = true,          -- Toggle with `:Gitsigns toggle_signs`
        numhl      = true,          -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false,         -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false,         -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',  -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,     -- Use default
        max_file_length = 40000,    -- Disable when file is longer than this (in lines)
        preview_config = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },

        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- Keybindings
            map('n', '<leader>hs', gs.stage_hunk)
            map('n', '<leader>hr', gs.reset_hunk)
            map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            vim.keymap.set('n', '<leader>gss', function() vim.cmd("Gitsigns toggle_signs")     end )
            vim.keymap.set('n', '<leader>gsn', function() vim.cmd("Gitsigns toggle_numhl")     end )
            vim.keymap.set('n', '<leader>gsl', function() vim.cmd("Gitsigns toggle_linehl")    end )
            vim.keymap.set('n', '<leader>gsw', function() vim.cmd("Gitsigns toggle_word_diff") end )

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
end

-- Set the Color Scheme one more Time
-- as some Plugin is overwritting the
-- colors...
if ( vim.g.loaded_molo == 1 ) then
    vim.cmd.colorscheme 'molo'
end

--}}}

