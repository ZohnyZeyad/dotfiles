return {
  'MeanderingProgrammer/render-markdown.nvim',
  lazy = false,
  enabled = true,
  ft = { "Avante", "codecompanion", "markdown" },
  opts = {
    preview = {
      filetypes = { "Avante", "codecompanion", "markdown" },
      ignore_buftypes = {},
    },
  },
}
