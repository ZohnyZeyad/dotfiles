return {
  'folke/todo-comments.nvim',
  enabled = false,
  event = { "BufReadPost" },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  config = function()
    vim.keymap.set("n", "]t", function()
      require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
  end
}
