return {
  "JavaHello/spring-boot.nvim",
  ft = { 'java', 'scala' },
  dependencies = {
    { "mfussenegger/nvim-jdtls", lazy = true }, -- or nvim-java, nvim-lspconfig
  },
  config = function()
    local spring_boot = require("spring_boot")
    spring_boot.setup({})
  end
}
