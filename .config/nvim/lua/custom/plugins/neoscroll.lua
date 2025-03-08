local modes = { 'n', 'v', 'x' }

return {
  "karb94/neoscroll.nvim",
  enabled = true,
  opts = {},

  keys = {
    {
      "<C-u>",
      function()
        require('neoscroll').ctrl_u({ duration = 200 })
        vim.api.nvim_feedkeys('zz', 'n', true)
      end,
      mode = modes
    },
    {
      "<C-d>",
      function()
        require('neoscroll').ctrl_d({ duration = 200 })
        vim.api.nvim_feedkeys('zz', 'n', true)
      end,
      mode = modes
    },
    {
      "<C-b>",
      function()
        require('neoscroll').ctrl_b({ duration = 250 })
        vim.api.nvim_feedkeys('zz', 'n', true)
      end,
      mode = modes
    },
    {
      "<C-f>",
      function()
        require('neoscroll').ctrl_f({ duration = 250 })
        vim.api.nvim_feedkeys('zz', 'n', true)
      end,
      mode = modes
    },
    {
      "zt",
      function() require('neoscroll').zt({ half_win_duration = 200 }) end,
      mode = modes
    },
    {
      "zz",
      function() require('neoscroll').zz({ half_win_duration = 200 }) end,
      mode = modes
    },
    {
      "zb",
      function() require('neoscroll').zb({ half_win_duration = 200 }) end,
      mode = modes
    },
  },

  config = function()
    require('neoscroll').setup({
      mappings = {},
      hide_cursor = false,         -- Hide cursor while scrolling
      stop_eof = false,            -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      duration_multiplier = 0.20,  -- Global duration multiplier
      easing = 'linear',           -- Default easing function
      pre_hook = nil,              -- Function to run before the scrolling animation starts
      post_hook = nil,             -- Function to run after the scrolling animation ends
      performance_mode = false,    -- Disable "Performance Mode" on all buffers.
      ignored_events = {           -- Events ignored while scrolling
        'WinScrolled', 'CursorMoved'
      },
    })
  end
}
