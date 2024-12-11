vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", '<cmd>Oil<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>lsp", "<cmd>LspRestart<cr>")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("v", "p", '"_dP', { desc = 'Paste without overwriting register' })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "==", "gg<S-v>G", { desc = 'Select All' })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-z>', '<cmd>redo<CR>')

-- These mappings control the size of splits (height/width)
vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-=>", "<C-W>+")
vim.keymap.set("n", "<M-->", "<C-W>-")

vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = 'Toggle comment line' })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = 'Toggle comment' })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

local set = vim.opt_local
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom_term_open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 5

    vim.bo.filetype = "terminal"
  end,
})

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-w>h', "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set('t', '<C-w>j', "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set('t', '<C-w>k', "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set('t', '<C-w>l', "<C-\\><C-n><C-w>l", { silent = true })
vim.keymap.set('t', '<A-l>', "<C-\\><C-n><C-w>l", { silent = true })
vim.keymap.set('t', '<A-h>', "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set('t', '<A-k>', "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set('t', '<A-j>', "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set('n', '<A-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<A-l>', '<C-w>l', { silent = true })
vim.keymap.set('n', '<A-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<A-k>', '<C-w>k', { silent = true })

vim.keymap.set("n", "<leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  set.scrolloff = 0
  vim.cmd.term()
end)

vim.keymap.set("n", "<leader>vt", function()
  vim.cmd.new()
  vim.cmd.wincmd "L"
  vim.cmd.term()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })
vim.keymap.set("n", "<leader>sr", "<cmd>SudaRead<CR>", { desc = "Re-open the current filw with sudo" })

--[[ vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end) ]] --
