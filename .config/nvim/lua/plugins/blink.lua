return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    enabled = false,
    opts = {},
  },

  {
    'saghen/blink.cmp',
    version = 'v0.*',
    event = { "LspAttach" },
    build = "cargo build --release",
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
        min_keyword_length = function()
          return vim.bo.filetype == 'markdown' and 2 or 0
        end,

        default = function(_)
          local ok, node = pcall(vim.treesitter.get_node)
          local defaults = { 'lsp', 'path', 'luasnip', 'buffer', 'lazydev', 'ripgrep' }
          if vim.bo.filetype == 'lua' then
            return { 'lsp', 'luasnip', 'path' }
          elseif ok and node and vim.tbl_contains({
                'comment',
                'comment_content',
                'line_comment',
                'block_comment',
                "string",
                "string_content",
              }, node:type()) then
            return { 'path', 'buffer' }
          else
            return defaults
          end
        end,

        cmdline = function()
          local _, type = pcall(vim.fn.getcmdtype)
          if type == '/' or type == '?' then
            return { 'path', 'buffer' }
          end
          if type == ':' then
            return { 'cmdline' }
          end
          return {}
        end,

        providers = {
          lsp = {
            async = true,
            score_offset = 50,
            fallbacks = { 'ctags', 'buffer' }
          },

          luasnip = { score_offset = -150 },

          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
            fallbacks = { 'lsp' },
          },

          ripgrep = {
            module = 'blink-ripgrep',
            name = 'Ripgrep',
            score_offset = -100,
            opts = {
              prefix_min_len = 3,
              context_size = 5,
              max_filesize = '1M',
              additional_rg_options = {},
              search_casing = '--smart-case',
              fallback_to_regex_highlighting = true,
            },
          },
        },
      },

      signature = {
        enabled = true,
        window = {
          border = 'rounded',
          treesitter_highlighting = true,
        }
      },

      fuzzy = {
        use_typo_resistance = false,
        use_proximity = true,
        sorts = { 'score', 'kind', 'sort_text', 'label' },
      },

      completion = {
        accept = {
          create_undo_point = true,
          auto_brackets = {
            enabled = false,
          },
        },

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
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
            scrollbar = false,
          },
        },
      },
    },

    opts_extend = { 'sources.default' }
  }
}
