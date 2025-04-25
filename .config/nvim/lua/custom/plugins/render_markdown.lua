return {
  'MeanderingProgrammer/render-markdown.nvim',
  lazy = false,
  enabled = false,
  ft = {},
  opts = {
    preview = {
      filetypes = {},
      ignore_buftypes = {},
    },
  },

  config = function()
    require('render-markdown').setup({
      code = {
        enabled = true,
        render_modes = false,
        sign = false,
        style = 'full',
        position = 'left',
        language_pad = 0,
        language_name = true,
        disable_background = { 'diff' },
        width = 'block',
        left_margin = 0,
        left_pad = 0,
        right_pad = 1,
        min_width = 0,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_language = nil,
        inline_pad = 0,
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      heading = {
        sign = false,
        -- icons = {},
      },
      checkbox = {
        enabled = false,
      },
      latex = {
        enabled = false,
      },
    })
  end,
}
