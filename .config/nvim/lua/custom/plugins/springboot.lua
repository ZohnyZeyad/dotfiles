return {
  "JavaHello/spring-boot.nvim",
  lazy = true,
  ft = { 'java', 'scala', 'yaml', 'jproperties' },
  dependencies = {
    { "mfussenegger/nvim-jdtls", lazy = true }, -- or nvim-java, nvim-lspconfig
  },
  config = function()
    local spring_boot = require("spring_boot")
    spring_boot.setup({})
  end
}
