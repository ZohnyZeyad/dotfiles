return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  -- comment the following line to ensure hub will be ready at the earliest
  -- cmd = "MCPHub", -- lazy load by default
  build = "npm install -g mcp-hub@latest",
  -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
  -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
  config = function()
    require("mcphub").setup({
      auto_approve = true, -- Auto approve mcp tool calls
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        }
      }
    })
  end,
}
