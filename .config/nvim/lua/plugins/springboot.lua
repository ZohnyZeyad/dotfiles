return {
  "JavaHello/spring-boot.nvim",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
  },
  config = function()
    require('spring_boot').setup({})
  end
}
