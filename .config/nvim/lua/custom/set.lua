--vim.opt.guicursor = ""
vim.opt.tags:append({ ".git/tags-dep", "tags-dep", ".git/tags", "tags" })

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

--vim.schedule(function()
--  vim.opt.clipboard = 'unnamedplus'
--end)

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = 'split'
-- vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt_global.completeopt = { "menu", "menuone", "noselect" }

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes:1"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.more = false
vim.opt.foldmethod = "manual"

vim.g.bigfile_size = 1024 * 1024 * 1 -- 1M

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.laststatus = 3
-- vim.g.suda_smart_edit = 1

-- vim.opt.colorcolumn = "80"

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 0
vim.g.netrw_sizestyle = 'h'
vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']() .. [[,.git/]]
