return {
  "neovim/nvim-lspconfig",
  name = "lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      'williamboman/mason.nvim',
      config = true,
      build = function()
        pcall(vim.api.nvim_cmd, 'MasonUpdate')
      end,
    },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.cmp',
    'netmute/ctags-lsp.nvim',
    {
      'folke/lazydev.nvim',
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
        enabled = true,
      },
    },
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    require('mason').setup()
    require('mason-tool-installer').setup {
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
        'stylua',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'jsonlint',
        'sql-formatter',
        'terraform-ls',
      }
    }
    vim.api.nvim_command('MasonToolsInstall')

    require('spring_boot').init_lsp_commands()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          relativePatternSupport = true,
        },
      },
    })

    require('mason-lspconfig').setup({
      automatic_installation = true,
      ensure_installed = {
        'lua_ls',
        'jdtls',
        'yamlls',
      },

      handlers = {
        function(server_name)
          if server_name ~= 'jdtls' then
            require('lspconfig')[server_name].setup {
              capabilities = capabilities
            }
          end
        end,
      }
    })

    local lspconfig = require('lspconfig')

    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = { version = "Lua 5.1" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          }
        }
      }
    }

    -- lspconfig.ctags_lsp.setup({
    --   filetypes = { "lua" }
    -- })

    vim.diagnostic.config({
      -- update_in_insert = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      {
        focus = false,
        border = "rounded",
      }
    )

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      {
        focus = false,
        border = "rounded",
      }
    )

    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
      })
    end

    sign({ name = 'DiagnosticSignError', text = '✘' })
    sign({ name = 'DiagnosticSignWarn', text = '▲' })
    sign({ name = 'DiagnosticSignHint', text = '⚑' })
    sign({ name = 'DiagnosticSignInfo', text = '»' })
  end
}
