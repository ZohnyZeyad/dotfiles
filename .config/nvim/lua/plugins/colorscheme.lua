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
    "erikbackman/brightburn.vim",
    enabled = false,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    opts = {},
    config = function()
      ColorMyPencils()
    end
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    config = function()
      require("tokyonight").setup({
        style = "moon",         -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark",   -- style for floating windows
        },
      })
    end
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
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
