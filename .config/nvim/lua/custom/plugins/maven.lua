return {
  -- {
  --   "eatgrass/maven.nvim",
  --   enabled = false,
  --   cmd = { "Maven", "MavenExec" },
  --   -- event = { "BufReadPost", "BufNewFile" },
  --   -- ft = { "java", "scala" },
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require('maven').setup({
  --       executable = "mvn",
  --       commands = {
  --         { cmd = { "clean", "compile" }, desc = "clean then compile" },
  --         { cmd = { "clean", "package" }, desc = "clean then package" },
  --         { cmd = { "clean", "install" }, desc = "clean then install" },
  --       },
  --     })
  --   end
  -- },
  {
    "oclay1st/maven.nvim",
    cmd = { "Maven", "MavenInit", "MavenExec" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = { { "<Leader>M", "<cmd>Maven<cr>", desc = "Maven" } }
  }
}
