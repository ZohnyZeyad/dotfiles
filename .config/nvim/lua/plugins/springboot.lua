return {
  "JavaHello/spring-boot.nvim",
  ft = { 'java', 'scala' },
  dependencies = {
    "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
  },
  config = function()
    require('spring_boot').setup({})
  end
}
