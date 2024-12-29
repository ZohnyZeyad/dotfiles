return {
  "scalameta/nvim-metals",

  dependencies = {
    "nvim-lua/plenary.nvim",
    { "j-hui/fidget.nvim", opts = {} },
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
      end
    },
  },

  ft = { "scala", "sbt", "sc" },

  opts = function()
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
      serverVersion = "latest.snapshot",
      showImplicitArguments = true,
      autoImportBuild = "all",
      fallbackScalaVersion = "2.13.15",
      inlayHints = {
        hintsInPatternMatch = { enable = true },
        implicitArguments = { enable = true },
        implicitConversions = { enable = true },
        inferredTypes = { enable = true },
        typeParameters = { enable = true },
      },
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      testUserInterface = "Test Explorer",
    }

    metals_config.init_options.statusBarProvider = "off"

    -- local root_markers = {
    --   'settings.gradle',
    --   'settings.gradle.kts',
    --   'pom.xml',
    --   'build.gradle',
    --   'mvnw',
    --   'gradlew',
    --   'build.gradle',
    --   'build.gradle.kts',
    --   '.git',
    -- }
    -- metals_config.root_patterns = root_markers

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    metals_config.capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      {
        workspace = {
          didChangeWatchedFiles = {
            relativePatternSupport = true,
          },
        },
      })

    metals_config.on_attach = function()
      require("metals").setup_dap()

      local map = vim.keymap.set
      map("n", "gd", function()
        require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
      end)
      map("n", "gD", vim.lsp.buf.declaration)
      map("n", "gi", vim.lsp.buf.implementation)
      map("n", "gr", function()
        require('telescope.builtin').lsp_references()
      end)
      map("n", "K", vim.lsp.buf.hover)
      map("n", "<leader>rn", vim.lsp.buf.rename)
      map("n", "<leader>ca", vim.lsp.buf.code_action)
      map("n", "<leader>cl", vim.lsp.codelens.run)
      map("n", "<leader>gds", function()
        require('telescope.builtin').lsp_document_symbols()
      end)
      map("n", "<leader>gws", function()
        require('telescope.builtin').lsp_workplace_symbols()
      end)
      map("n", "<leader>gd", function()
        require('telescope.builtin').diagnostics()
      end)
      map("n", "<leader>ff", vim.lsp.buf.format)
      map("n", "<leader>sh", vim.lsp.buf.signature_help)

      map("n", "<leader>ws", function()
        require("metals").hover_worksheet()
      end)

      map("n", "<leader>fm", function()
        require('telescope').extensions.metals.commands()
      end)

      map("n", "<leader>pt", function()
        require('metals.tvp').reveal_in_tree()
      end)

      map("n", "<leader>tv", function()
        require('metals.tvp').toggle_tree_view()
      end)

      -- all workspace diagnostics
      map("n", "<leader>aa", vim.diagnostic.setqflist)

      -- all workspace errors
      map("n", "<leader>ae", function()
        vim.diagnostic.setqflist({ severity = "E" })
      end)

      -- all workspace warnings
      map("n", "<leader>aw", function()
        vim.diagnostic.setqflist({ severity = "W" })
      end)

      -- buffer diagnostics only
      map("n", "<leader>d", vim.diagnostic.setloclist)

      map("n", "[d", function()
        vim.diagnostic.goto_prev({ wrap = false })
      end)

      map("n", "]d", function()
        vim.diagnostic.goto_next({ wrap = false })
      end)

      map("n", "<leader>dc", function()
        require("dap").continue()
      end)

      map("n", "<leader>dr", function()
        require("dap").repl.toggle()
      end)

      map("n", "<leader>dK", function()
        require("dap.ui.widgets").hover()
      end)

      map("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
      end)

      map("n", "<leader>dso", function()
        require("dap").step_over()
      end)

      map("n", "<leader>dsi", function()
        require("dap").step_into()
      end)

      map("n", "<leader>dl", function()
        require("dap").run_last()
      end)
    end

    return metals_config
  end,

  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
}
