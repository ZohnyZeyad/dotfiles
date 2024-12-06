return {
  'softinio/scaladex.nvim',
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = false,
  config = function()
    pcall(require('telescope').load_extension, 'scaladex')

    vim.keymap.set('n', '<leader>si', function()
      require('telescope').extensions.scaladex.scaladex.search()
    end, { noremap = true, silent = true })
  end
}
