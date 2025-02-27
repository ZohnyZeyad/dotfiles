return {
  "chrishrb/gx.nvim",
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
  submodules = false,
  config = true,

  -- config = function()
  --   require("gx").setup {
  --     open_browser_app = "os_specific",
  --     -- open_browser_args = { "--background" },
  --     handlers = {
  --       plugin = true,
  --       github = true,
  --       brewfile = true,
  --       package_json = true,
  --       search = true,
  --       jira = {
  --         name = "jira",
  --         handle = function(mode, line, _)
  --           local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
  --           if ticket and #ticket < 20 then
  --             return "https://jira.cengage.com/browse/" .. ticket
  --           end
  --         end,
  --       },
  --     },
  --     handler_options = {
  --       search_engine = "google",
  --       select_for_search = false,
  --       git_remotes = { "upstream", "origin" },
  --       git_remote_push = false,
  --     },
  --   }
  -- end,
}
