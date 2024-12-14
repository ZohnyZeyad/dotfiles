require("zeyad.set")
require("zeyad.remap")
require("zeyad.lazy_init")

local augroup = vim.api.nvim_create_augroup
local remove_spaces_group = augroup('RemoveTrailingSpaces', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})
local reload_conf_group = augroup('ReloadConfigs', { clear = true })

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = remove_spaces_group,
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end
})

autocmd('BufWritePost', {
  group = reload_conf_group,
  pattern = {
    '~/.config/kitty/kitty.conf',
    '~/.dotfiles/.config/kitty/kitty.conf'
  },
  callback = function()
    vim.fn.system('kill -SIGUSR1 $(pgrep kitty)')
  end
})

autocmd('BufWritePost', {
  group = reload_conf_group,
  pattern = '~/.tmux.conf',
  callback = function()
    vim.fn.system('tmux source-file ~/.tmux.conf')
    vim.fn.system('tmux display-message "Reloaded ~/.tmux.conf!"')
  end
})

autocmd('LspAttach', {
  group = remove_spaces_group,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "gd", function()
      require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
    end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    -- vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gi", function()
      require('telescope.builtin').lsp_implementations({ jump_type = 'vsplit' })
    end, opts)
    -- vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gr", function()
      require('telescope.builtin').lsp_references()
    end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.run() end, opts)
    vim.keymap.set("n", "<leader>gds", function()
      require('telescope.builtin').lsp_document_symbols()
    end, opts)
    vim.keymap.set("n", "<leader>gws", function()
      require('telescope.builtin').lsp_workplace_symbols()
    end, opts)
    vim.keymap.set("n", "<leader>gd", function()
      require('telescope.builtin').diagnostics()
    end, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>sh", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next({ wrap = false }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev({ wrap = false }) end, opts)

    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    if client.supports_method('textDocument/formatting') then
      autocmd('BufWritePre', {
        buffer = e.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = e.buf, id = client.id })
        end,
      })
    end
  end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 0
vim.g.netrw_sizestyle = 'h'
vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']() .. [[,.git/]]
