return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      'williamboman/mason.nvim',
      config = true,
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },
    "williamboman/mason-lspconfig.nvim",
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "FelipeLema/cmp-async-path",
    "hrsh7th/cmp-cmdline",
    -- "hrsh7th/nvim-cmp",
    { "yioneko/nvim-cmp",  branch = "perf-up" },
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "onsails/lspkind.nvim",
    "petertriho/cmp-git",
    "SergioRibera/cmp-dotenv",
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "rafamadriz/friendly-snippets",
        {
          "benfowler/telescope-luasnip.nvim",
          module = "telescope._extensions.luasnip",
        },
      },
    },
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      lspCapabilities,
      cmp_lsp.default_capabilities(lspCapabilities))

    require("mason").setup()

    require('mason-tool-installer').setup {
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
        "stylua",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "jsonlint",
        "sql-formatter",
        "terraform-ls",
      }
    }

    vim.api.nvim_command('MasonToolsInstall')

    -- require('spring_boot').init_lsp_commands()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "jdtls",
        "yamlls",
      },

      handlers = {
        function(server_name)
          if server_name ~= 'jdtls' then
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,

        -- ["jdtls"] = function()
        --   local lspconfig = require("lspconfig")
        --
        --   local opts = {
        --     capabilities = capabilities,
        --   }
        --
        --   local require_ok, conf_opts = pcall(require, "plugins.lsp.settings.jdtls")
        --
        --   if require_ok then
        --     opts = vim.tbl_deep_extend("force", conf_opts, opts)
        --   end
        --
        --   lspconfig.jdtls.setup(opts)
        -- end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").filetype_extend("java", { "javadoc", "java-tests" })
    require("luasnip").filetype_extend("scala", { "javadoc" })
    require("luasnip").filetype_extend("sh", { "shelldoc" })
    require("luasnip").filetype_extend("typescript", { "tsdoc" })
    require("luasnip").filetype_extend("javascript", { "jsdoc" })

    local lspkind = require('lspkind')

    local compare = cmp.config.compare
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noselect' },
      window = {
        documentation = cmp.config.window.bordered()
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        --[[["<Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
                ["<S-Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,]] --
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "nvim_lsp_signature_help" },
      }, {
        { name = 'buffer' },
        { name = 'async_path' },
        -- { name = 'path' },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          before = function(_, vim_item)
            return vim_item
          end
        })
      }
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })
    require("cmp_git").setup()

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'async_path' },
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    cmp.setup.filetype("sh", {
      sources = cmp.config.sources({
        { name = "dotenv" },
        { name = "cmdline" },
      }),
    })

    cmp.setup.filetype({ "scala", "sc", "sbt", "java" }, {
      preselect = cmp.PreselectMode.None, -- disable preselection
      sorting = {
        priority_weight = 2,
        comparators = {
          compare.offset,
          compare.score,
          compare.sort_text,
          compare.recently_used,
          compare.kind,
          compare.length,
          compare.order,
        },
      },
      -- if you want to add preselection you have to set completeopt to new values
      completion = {
        -- completeopt = 'menu,menuone,noselect', <---- this is default value,
        completeopt = 'menu,menuone', -- remove noselect
      },
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

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

    -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    --   vim.lsp.handlers.hover,
    --   {
    --     border = "rounded",
    --     style = "minimal",
    --     header = "",
    --     prefix = "",
    --   }
    -- )
    --
    -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    --   vim.lsp.handlers.signature_help,
    --   {
    --     border = "rounded",
    --     style = "minimal",
    --     header = "",
    --     prefix = "",
    --   }
    -- )
  end
}
