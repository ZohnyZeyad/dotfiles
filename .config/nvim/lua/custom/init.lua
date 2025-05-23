require("custom.options")
require("custom.keymaps")

function R(name)
  require("plenary.reload").reload_module(name)
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local remove_spaces_group = augroup('RemoveTrailingSpaces', { clear = true })
local lsp_group = augroup('LspAttachMappings', { clear = true })
local yank_group = augroup('HighlightYank', {})
local reload_conf_group = augroup('ReloadConfigs', { clear = true })
local term_group = vim.api.nvim_create_augroup("CustomTermOpen", { clear = true })
local codecompanion_group = vim.api.nvim_create_augroup("CompanionChatHooks", {})

local set = vim.opt_local
autocmd("TermOpen", {
  group = term_group,
  callback = function()
    set.number = false
    set.relativenumber = false

    vim.bo.filetype = "terminal"
  end,
})

autocmd({ "User" }, {
  pattern = "CodeCompanionChat*",
  group = codecompanion_group,
  callback = function(request)
    if request.match == "CodeCompanionChatOpened" then
      set.number = false
      set.relativenumber = false
      vim.bo.filetype = "codecompanion"
    end
  end,
})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.hl.on_yank({
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

local home = vim.env.HOME

autocmd('BufWritePost', {
  group = reload_conf_group,
  pattern = {
    home .. '/.config/kitty/*.conf',
    home .. '/.dotfiles/.config/kitty/*.conf'
  },
  callback = function()
    vim.fn.system('kill -SIGUSR1 $(pgrep kitty)')
  end
})

autocmd('BufWritePost', {
  group = reload_conf_group,
  pattern = {
    home .. '/.tmux.conf',
    home .. '/.dotfiles/.tmux.conf'
  },
  callback = function()
    vim.fn.system('tmux source-file ~/.tmux.conf')
    vim.fn.system('tmux display-message "Reloaded ~/.tmux.conf!"')
  end
})

autocmd('BufWritePost', {
  group = reload_conf_group,
  pattern = {
    home .. '/.zsh*',
    home .. '/.dotfiles/.zsh*'
  },
  callback = function()
    vim.fn.system('source ~/.zshrc')
    print('Reloaded ~/.zshrc!')
  end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

autocmd('LspAttach', {
  group = lsp_group,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "gd", function()
      require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
    end, opts)
    vim.keymap.set("n", "gt", function()
      require('telescope.builtin').lsp_type_definitions({ jump_type = 'vsplit' })
    end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function()
      require('telescope.builtin').lsp_implementations({ jump_type = 'vsplit' })
    end, opts)
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
      require('telescope.builtin').lsp_dynamic_workplace_symbols()
    end, opts)
    vim.keymap.set("n", "<leader>gd", function()
      require('telescope.builtin').diagnostics()
    end, opts)
    vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set("n", "<leader>sh", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/formatting') then
      if not ((client.name == "metals" and vim.bo.filetype == "scala") or (client.name == "jdtls" and vim.bo.filetype == "java")) then
        autocmd('BufWritePre', {
          buffer = e.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = e.buf, id = client.id })
          end,
        })
      end
    end
  end
})
