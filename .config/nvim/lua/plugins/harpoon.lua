return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",

  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-q>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-e>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-r>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-y>", function() harpoon:list():select(4) end)

    vim.keymap.set("n", "<leader><C-e>", function() harpoon:list():replace_at(1) end)
    vim.keymap.set("n", "<leader><C-r>", function() harpoon:list():replace_at(2) end)
    vim.keymap.set("n", "<leader><C-t>", function() harpoon:list():replace_at(3) end)
    vim.keymap.set("n", "<leader><C-y>", function() harpoon:list():replace_at(4) end)
  end
}
