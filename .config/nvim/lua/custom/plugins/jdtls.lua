return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java', 'scala' },
  -- event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "mfussenegger/nvim-dap",
  }
}
