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
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      local map = vim.keymap.set
      map("n", "<leader>dc", function() dap.continue() end)
      map("n", "<leader>dr", function() dap.repl.toggle() end)
      map("n", "<leader>dK", function() require("dap.ui.widgets").hover() end)
      map("n", "<leader>db", function() dap.toggle_breakpoint() end)
      map("n", "<leader>dlb", function() dap.list_breakpoints() end)
      map("n", "<leader>dcb", function() dap.clear_breakpoints() end)
      map("n", "<leader>dso", function() dap.step_over() end)
      map("n", "<leader>dsO", function() dap.step_out() end)
      map("n", "<leader>dsi", function() dap.step_into() end)
      map("n", "<leader>dsb", function() dap.step_back() end)
      map("n", "<leader>dl", function() dap.run_last() end)
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      { "nvim-neotest/nvim-nio", lazy = true },
    },

    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function()
      require('mason-nvim-dap').setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        ---@see mason-nvim-dap README for more information
        handlers = {},

        ensure_installed = {
          "javadbg", "javatest",
          "bash"
        },
      })
    end,
  }
}
