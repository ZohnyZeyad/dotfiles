-- Snippets expansion function
local function snippets_expand(snippet)
  require('luasnip.loaders.from_vscode').lazy_load()

  local luasnip = require('luasnip')
  luasnip.filetype_extend('java', { 'javadoc', 'java-tests' })
  luasnip.filetype_extend('scala', { 'javadoc' })
  luasnip.filetype_extend('sh', { 'shelldoc' })
  luasnip.filetype_extend('typescript', { 'tsdoc' })
  luasnip.filetype_extend('javascript', { 'jsdoc' })

  luasnip.lsp_expand(snippet)
end

-- Snippets active check function
local function snippets_active(filter)
  local luasnip = require('luasnip')
  if filter and filter.direction then
    return luasnip.jumpable(filter.direction)
  end
  return luasnip.in_snippet()
end

-- Snippets jump function
local function snippets_jump(direction)
  require('luasnip').jump(direction)
end

-- Default completion sources function
local function sources_default_function(_)
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
    -- In comment or string, only suggest path and buffer completions
    return { 'path', 'buffer' }
  else
    return defaults -- Otherwise, use default sources
  end
end

-- Cmdline completion sources function
local function cmdline_sources_function()
  local _, type = pcall(vim.fn.getcmdtype)
  if type == '/' or type == '?' then
    return { 'buffer', 'path' } -- For search commands, use buffer and path
  end
  if type == ':' then
    return { 'cmdline' } -- For command-line commands, use cmdline source
  end
  return {}              -- Otherwise, no sources
end

-- Define completion providers for sources
local completion_providers = {
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

  avante = {
    module = 'blink-cmp-avante',
    name = 'Avante',
    score_offset = 150,
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
      get_cwd = function(context) -- Function to get current working directory for path completion
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
}

return {
  -- Compatibility module for blink.nvim
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    enabled = true,
    opts = {},
  },

  -- Main blink.cmp configuration
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
      'Kaiser-Yang/blink-cmp-avante',
    },

    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      snippets = {
        preset = 'luasnip',
        expand = snippets_expand, -- Function to expand snippets
        active = snippets_active, -- Function to check if snippets are active
        jump = snippets_jump,     -- Function to jump between snippet locations
      },

      sources = {
        min_keyword_length = function()
          return vim.bo.filetype == 'markdown' and 2 or 0
        end,

        default = sources_default_function,

        per_filetype = {
          lua = { 'lazydev', 'lsp', 'snippets', 'buffer', 'path' },
          AvanteInput = { 'avante' },
          codecompanion = { "codecompanion" },
        },

        providers = completion_providers,
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = 'cmdline',
          -- ['<S-Tab>'] = { 'select_prev', 'fallback' },
          -- ['<Tab>'] = { 'select_next', 'fallback' },
          -- ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },

        sources = cmdline_sources_function,

        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = nil,
          },

          menu = {
            auto_show = false,
            draw = {
              columns = { { 'label', 'label_description', gap = 1 } },
            },
          }
        }
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
        ---@diagnostic disable-next-line: unused-local
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
