vim.bo.formatprg = "scalafmt --stdin"

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = {
--     "*.scala",
--     "*.sc",
--   },
--   callback = function()
--     vim.cmd("silent! !scalafmt --stdin < % > %")
--   end
-- })

vim.opt.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt.expandtab = true
