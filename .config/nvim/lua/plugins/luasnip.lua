return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  lazy = true,
  build = "make install_jsregexp",
  dependencies = {
    {
      "benfowler/telescope-luasnip.nvim",
      module = "telescope._extensions.luasnip",
    },
  },
}
