return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { pane = 2,          padding = 5 },
        { section = "keys",  gap = 1,    padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 2
        },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 2
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    gitbrowse = {
      ---@type "repo" | "branch" | "file" | "commit" | "permalink"
      what = "file",
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    indent = {
      enabled = false,
      indent = {
        priority = 1,
        enabled = true,
        only_scope = false,  -- only show indent guides of the scope
        only_current = true, -- only show indent guides in the current window
      },
      animate = {
        enabled = true,
        style = "out",
        easing = "linear",
        duration = {
          step = 20,   -- ms per step
          total = 100, -- maximum duration
        },
      },
      scope = {
        enabled = true,
        priority = 200,
        only_current = true, -- only show scope in the current window
      },
    },
    input = { enabled = true },
    image = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      -- minimum log level to display. TRACE is the lowest
      -- all notifications are stored in history
      level = vim.log.levels.TRACE,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = {
      enabled = false,
      animate = {
        duration = { step = 15, total = 150 },
        easing = "linear",
      },
      -- faster animation when repeating scroll after delay
      animate_repeat = {
        delay = 50, -- delay in ms before using the repeat animation
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
    },
    words = {
      enabled = false,
      debounce = 50,
      notify_end = false,
    },
  },
  keys = {
    { "<leader>nt",  function() Snacks.explorer() end,                desc = "File Explorer" },
    { "<leader>nh",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },
    { "<leader>bd",  function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
    { "<leader>gL",  function() Snacks.picker.git_log() end,          desc = "Git Log" },
    { "<leader>glf", function() Snacks.picker.git_log_file() end,     desc = "Git Log File" },
    { "<leader>gB",  function() Snacks.gitbrowse() end,               desc = "Git Browse",               mode = { "n", "v" } },
    { "<leader>gg",  function() Snacks.lazygit() end,                 desc = "Lazygit" },
    { "<leader>cR",  function() Snacks.rename.rename_file() end,      desc = "Rename File" },
    { "<leader>un",  function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
    { "]]",          function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",           mode = { "n", "t" } },
    { "[[",          function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",           mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.diagnostics():map("<leader>dt")
        Snacks.toggle.indent():map("<leader>it")
      end,
    })
  end,
}
