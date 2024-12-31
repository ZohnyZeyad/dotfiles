return {
  "nvim-treesitter/nvim-treesitter",
  name = "treesitter",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      name = "treesitter-textobj",
      lazy = true
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      name = "treesitter-refactor",
      enabled = false,
      lazy = true
    },
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    ---@diagnostic disable-next-line: missing-fields
    treesitter.setup({
      ensure_installed = {
        "vim", "vimdoc", "lua",
        "java", "scala",
        "json", "yaml", "xml", "toml", "tmux",
        "dockerfile", "terraform",
        "query", "sql",
        "markdown", "markdown_inline",
        "git_rebase", "diff", "gitcommit", "gitignore",
        "regex",
      },

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,
      sync_install = false,

      ignore_install = {},
      indent = { enable = true },

      highlight = {
        enable = true,
        use_languagetree = true,

        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        additional_vim_regex_highlighting = { "markdown" },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

            ["am"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            ["im"] = { query = "@call.inner", desc = "Select inner part of a function call" },
          },

          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'v',
            ['@class.outer'] = '<c-v>',
          },

          include_surrounding_whitespace = false,
        },

        move = {
          enable = true,
          set_jumps = true,

          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },

          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },

          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },

          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },

        swap = {
          enable = true,

          swap_next = {
            ["<leader>nf"] = "@function.outer",
            ["<leader>na"] = "@parameter.outer",
            ["<leader>nA"] = "@parameter.inner",
          },

          swap_previous = {
            ["<leader>bf"] = "@function.outer",
            ["<leader>ba"] = "@parameter.outer",
            ["<leader>bA"] = "@parameter.inner",
          },
        },
      },

      -- refactor = {
      --   highlight_definitions = {
      --     enable = false,
      --     clear_on_cursor_move = true,
      --   },
      -- },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end
}
