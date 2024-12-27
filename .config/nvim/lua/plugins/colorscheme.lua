---@diagnostic disable: missing-fields

function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {

  {
    "Mofiqul/dracula.nvim",
    enabled = false,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        no_italic = true,
        term_colors = true,
        transparent_background = true,
        styles = {
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
        },
        -- color_overrides = {
        --   mocha = {
        --     base = "#000000",
        --     mantle = "#000000",
        --     crust = "#000000",
        --   },
        -- },
        integrations = {
          blink_cmp = true,
          harpoon = true,
          mason = true,
          telescope = {
            enabled = true,
            -- style = "nvchad",
          },
        },
      })

      ColorMyPencils("catppuccin")
    end
  },

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          transparent = true,
          terminal_colors = true,
        }
      })

      ColorMyPencils('github_dark_default')
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night or day
        transparent = true,
        terminal_colors = true,
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent",
          floats = "transparent",
        },
      })

      ColorMyPencils("tokyonight-night")
    end
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        disable_background = true,

        enable = {
          terminal = true,
        },

        styles = {
          bold = true,
          italic = false,
          transparency = true,
        }
      })

      ColorMyPencils()
    end
  },

}
