-- General UI Settings
vim.opt.laststatus = 3       -- Always show the status line
vim.opt.termguicolors = true -- Enable true color support
vim.opt.scrolloff = 8        -- Keep 8 lines visible when scrolling
vim.opt.signcolumn = "yes:1" -- Always show the sign column, with a width of 1
vim.opt.more = false         -- Don't pause for long messages
vim.opt.colorcolumn = "100"  -- Highlight the 100th column
-- vim.opt.cursorline = true -- Highlight the current line.

-- Numbering
vim.opt.nu = true
vim.opt.relativenumber = true

-- Mouse and cursor
vim.opt.mouse = 'a'
-- vim.opt.guicursor = ""  --  This is often set in a GUI-specific config (e.g., ginit.vim) or left at the default.

-- Splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Command-line Completion
vim.opt.inccommand = 'split'                                   -- Show the effects of a command incrementally
vim.opt_global.completeopt = { "menu", "menuone", "noselect" } -- Completion options

-- Tabs, Indentation, and Whitespace
vim.opt.tabstop = 4        -- A tab is 4 spaces
vim.opt.softtabstop = 4    -- Use 4 spaces when editing
vim.opt.shiftwidth = 4     -- Indent by 4 spaces
vim.opt.expandtab = true   -- Expand tabs to spaces
vim.opt.smartindent = true -- Smart auto-indentation
vim.opt.ignorecase = true  -- Ignore case in searches
vim.opt.smartcase = true   -- ...unless there are uppercase letters
vim.opt.wrap = false       -- Don't wrap lines

-- File Handling
vim.opt.swapfile = false                               -- Disable swap files
vim.opt.backup = false                                 -- Disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Set the undo directory
vim.opt.undofile = true                                -- Enable persistent undo

-- Search
vim.opt.incsearch = true -- Highlight matches as you type
-- vim.opt.hlsearch = false -- Disable highlighting of search results.

-- Tags
vim.opt.tags:append({ ".git/tags-dep", "tags-dep", ".git/tags", "tags" })

-- File Name Completion
vim.opt.isfname:append("@-@")

-- Update Time
vim.opt.updatetime = 50

-- Shada (Shared Data)
vim.opt.shada = { "'10", "<0", "s10", "h" }

-- Big File Settings
vim.g.bigfile_size = 1024 * 1024 * 1 -- 1M (Threshold for disabling some features)

-- Disable Unused Providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Netrw (File Explorer) Settings
vim.g.netrw_browse_split = 0 -- Open files in the current window
vim.g.netrw_banner = 0       -- Hide the netrw banner
vim.g.netrw_winsize = 25     -- Set the default netrw window size
vim.g.netrw_liststyle = 0    -- Use the default list style
vim.g.netrw_sizestyle = 'h'  -- Use human-readable sizes
-- vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']() .. [[,.git/]] -- Hide files ignored by git

vim.opt.foldmethod = "manual"
-- vim.opt.clipboard = 'unnamedplus'
-- vim.g.suda_smart_edit = 1 -- Automatically write with sudo using suda.nvim
