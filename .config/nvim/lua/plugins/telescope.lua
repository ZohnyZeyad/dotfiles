return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",

  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    {
      "benfowler/telescope-luasnip.nvim",
      module = "telescope._extensions.luasnip",
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font
    },
  },

  config = function()
    local data = assert(vim.fn.stdpath "data") --[[@as string]]

    require('telescope').setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = "󱞩 ",
        path_display = { "filename_first" },
        -- layout_strategy = "vertical",
      },
      pickers = {
        find_files = {
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        }
      },
      extensions = {
        wrap_results = true,
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        luasnip = {
          require("telescope.themes").get_dropdown(),
        },
      }
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'luasnip')

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set("n", "<leader>fg", require "plugins.telescope.multi-ripgrep", { desc = '[F]ind [G]rep' })
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [F]iles' })
    vim.keymap.set('n', '<leader>sgc', builtin.git_commits, { desc = '[S]earch [G]it [C]ommits' })
    vim.keymap.set('n', '<leader>sgs', builtin.git_status, { desc = '[S]earch [G]it [S]tatus' })
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})

    vim.keymap.set('n', '<leader>gw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, { desc = '[G]rep [w]ord' })

    vim.keymap.set('n', '<leader>gW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = '[G]rep [W]ord' })

    vim.keymap.set('n', '<leader>fs', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = '[F]ind [S]tring' })

    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>ts', function()
      require('telescope').extensions.luasnip.luasnip {}
    end, { desc = '[T]elescope [S]nip' })
  end
}
