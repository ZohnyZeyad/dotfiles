return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = {},
  },

  {
    'saghen/blink.cmp',
    version = 'v0.*',
    event = { "LspAttach" },
    dependencies = {
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip',
      'mikavilpas/blink-ripgrep.nvim',
    },

    opts = {
      keymap = { preset = 'default', },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      snippets = {
        expand = function(snippet)
          require('luasnip.loaders.from_vscode').lazy_load()

          require('luasnip').filetype_extend('java', { 'javadoc', 'java-tests' })
          require('luasnip').filetype_extend('scala', { 'javadoc' })
          require('luasnip').filetype_extend('sh', { 'shelldoc' })
          require('luasnip').filetype_extend('typescript', { 'tsdoc' })
          require('luasnip').filetype_extend('javascript', { 'jsdoc' })

          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },

      sources = {
        -- enabled_providers = { 'lsp', 'path', 'luasnip', 'buffer', 'lazydev' },
        enabled_providers = function(_)
          local node = vim.treesitter.get_node()
          if vim.bo.filetype == 'lua' then
            return { 'lsp', 'luasnip', 'path' }
          elseif node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'path', 'buffer' }
          else
            return { 'lsp', 'path', 'luasnip', 'buffer', 'lazydev', 'ripgrep' }
          end
        end
      },

      providers = {
        -- lsp = { fallback_for = { 'lazydev' } },

        luasnip = { score_offset = -5 },

        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', fallbacks = { 'lsp' } },

        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          score_offset = -4,
          opts = {
            prefix_min_len = 3,
            context_size = 5,
            max_filesize = "1M",
            additional_rg_options = {},
            search_casing = "--smart-case",
          },
        },
      },

      signature = {
        enabled = true,
        border = "rounded",
      },

      fuzzy = {
        use_typo_resistance = false,
        use_proximity = false,
        sorts = { 'score', 'sort_text', 'kind', 'label' },
      },

      completion = {
        menu = {
          border = vim.g.border_style,
          scrollbar = false,
          draw = {
            treesitter = { 'lsp' },
            columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
          },
        },

        documentation = {
          auto_show_delay_ms = 0,
          auto_show = true,
          window = {
            border = "rounded",
            scrollbar = false,
          },
        },
      },
    },

    opts_extend = { 'sources.default' }
  }
}
