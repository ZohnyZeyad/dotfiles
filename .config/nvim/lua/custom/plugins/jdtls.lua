return {
  'mfussenegger/nvim-jdtls',
  enabled = true,
  ft = { 'java', 'scala' },
  -- event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "mfussenegger/nvim-dap",
  }
}
