return {
  "tpope/vim-fugitive",
  cmd = "Git",
  config = function()
    local Zeyad_Fugitive = vim.api.nvim_create_augroup("Zeyad_Fugitive", {})

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWinEnter", {
      group = Zeyad_Fugitive,
      pattern = "*",
      callback = function()
        if vim.bo.ft ~= "fugitive" then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "f<leader>", ":Git fetch ", opts)
        vim.keymap.set("n", "p<leader>", ":Git push ", opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
          vim.cmd.Git({ 'pull', '--rebase' })
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "pt<leader>", ":Git push -u origin ", opts);
      end,
    })

    vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    vim.keymap.set("n", "<leader>fds", "<cmd>Gvdiffsplit!<CR>")
  end
}
