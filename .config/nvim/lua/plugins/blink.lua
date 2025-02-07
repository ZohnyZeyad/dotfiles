return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    enabled = true,
    opts = {},
  },

  {
    'saghen/blink.cmp',
    version = 'v0.*',
    enabled = function()
      return not vim.tbl_contains({ "typr" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
    end,
    event = { "LspAttach" },
    build = "cargo build --release",
    dependencies = {
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip',
      'mikavilpas/blink-ripgrep.nvim',
    },

    opts = {
      keymap = {
        preset = 'default',
        cmdline = {
          preset = 'enter',
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<Tab>'] = { 'select_next', 'fallback' },
        },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      snippets = {
        preset = 'luasnip',
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
          local defaults = {
            'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'ripgrep',
          }
          if ok and node and vim.tbl_contains({
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

        per_filetype = {
          lua = { 'lazydev', 'lsp', 'snippets', 'buffer', 'path' },
          AvanteInput = { 'avante_commands', 'avante_mentions', 'avante_files' }
        },

        cmdline = function()
          local _, type = pcall(vim.fn.getcmdtype)
          if type == '/' or type == '?' then
            return { 'buffer', 'path' }
          end
          if type == ':' then
            return { 'cmdline' }
          end
          return {}
        end,

        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            async = true,
            score_offset = 90,
            fallbacks = { 'snippets', 'ctags', 'buffer' }
          },

          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
            fallbacks = { 'lsp' },
          },

          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 110, -- show at a higher priority than lsp
            opts = {},
          },

          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 120, -- show at a higher priority than lsp
            opts = {},
          },

          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- show at a higher priority than lsp
            opts = {},
          },

          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            fallbacks = { "snippets", "buffer", "ripgrep" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },

          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 3,
          },

          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 4,
            score_offset = 85,
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
        trigger = {
          show_on_insert_on_trigger_character = false,
        },
        window = {
          border = 'rounded',
          treesitter_highlighting = true,
        }
      },

      fuzzy = {
        max_typos = function(keyword) return 0 end, -- Match fzf behavior. No typos allowed.
        use_frecency = true,
        use_proximity = true,
        sorts = { 'score', 'kind', 'sort_text', 'label' },
      },

      completion = {
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active({ direction = 1 })
            end,
            auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
          }
        },

        trigger = {
          show_on_insert_on_trigger_character = false,
        },

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
