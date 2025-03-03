return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")
      dap.configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "RunOrTest",
          metals = {
            runType = "runOrTestFile",
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }

      dap.listeners.after["event_terminated"]["nvim-metals"] = function()
        dap.repl.open()
      end

      dap.configurations.java = {
        {
          name = "hprof (pick path)",
          request = "launch",
          type = "hprof",
          filepath = function()
            return require("dap.utils").pick_file({
              executables = false,
              filter = "%.hprof$"
            })
          end,
        },
        {
          name = "hprof (prompt path)",
          request = "launch",
          type = "hprof",
          filepath = function()
            local path = vim.fn.input("hprof path: ", "", "file")
            return path and vim.fn.fnamemodify(path, ":p") or dap.ABORT
          end,
        },
      }

      local map = vim.keymap.set
      map("n", "<leader>dc", function() dap.continue() end)
      map("n", "<leader>dr", function() dap.repl.toggle() end)
      map("n", "<leader>dK", function() require("dap.ui.widgets").hover() end)
      map("n", "<leader>db", function() dap.toggle_breakpoint() end)
      map("n", "<leader>dso", function() dap.step_over() end)
      map("n", "<leader>dsi", function() dap.step_into() end)
      map("n", "<leader>dl", function() dap.run_last() end)
    end
  },

}
