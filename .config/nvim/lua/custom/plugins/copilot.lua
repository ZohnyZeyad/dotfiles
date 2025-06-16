return {
  -- "github/copilot.vim",
  "zbirenbaum/copilot.lua",
  enabled = true,
  cmd = "Copilot",
  event = "InsertEnter",

  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },

      panel = { enabled = false },

      filetypes = {
        ["."] = true,
        markdown = true,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            -- disable for .env files
            return false
          end
          return true
        end,
      },

      should_attach = function(_, bufname)
        if string.match(bufname, "env") then
          return false
        end
        return true
      end,

      workspace_folders = {
        "~/Cengage/RTA/Stash/CAP",
        "~/Cengage/RTA/Stash/AINFRA",
        "~/Cengage/RTA/Stash/ALTCS",
        "~/.config/nvim",
      },
    })
  end,
}
