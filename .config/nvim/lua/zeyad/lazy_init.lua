local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  concurrency = 4,
  change_detection = { notify = false },
  install = {
    colorscheme = { "rose-pine" },
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "osc52",
        "parser",
        "gzip",
        "netrwPlugin",
        "health",
        "man",
        "matchit",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "shadafile",
        "spellfile",
        "editorconfig",
      },
    },
  },
  ui = {
    border = "rounded",
    title = "lazy.nvim",
    size = { width = 0.8, height = 0.8 },
  },
})
