return {
  'mistweaverco/kulala.nvim',
  ft = { "http", "rest" },
  opts = {
    default_view = "headers_body",
    global_keymaps = {
      ["Send request"] = { -- sets global mapping
        "<leader>Rs",
        function() require("kulala").run() end,
        mode = { "n", "v" },  -- optional mode, default is v
        desc = "Send request" -- optional description, otherwise inferred from the key
      },
      ["Send all requests"] = {
        "<leader>Ra",
        function() require("kulala").run_all() end,
        mode = { "n", "v" },
        ft = "http", -- sets mapping for *.http files only
      },
      ["Replay the last request"] = {
        "<leader>Rr",
        function() require("kulala").replay() end,
        ft = { "http", "rest" }, -- sets mapping for specified file types
      },
      ["Find request"] = false   -- set to false to disable
    },
  }
}
