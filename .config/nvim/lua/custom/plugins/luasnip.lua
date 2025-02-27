return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  build = "make install_jsregexp",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    {
      "benfowler/telescope-luasnip.nvim",
      module = "telescope._extensions.luasnip",
    },
  },
}
