return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "mfussenegger/nvim-dap",
    },

    ft = { "scala", "sbt", "sc" },

    opts = function()
      local metals_config = require("metals").bare_config()

      local home = vim.env.HOME
      metals_config.settings = {
        javaHome = home .. "/.sdkman/candidates/java/11.0.26-amzn",
        serverVersion = "latest.snapshot",
        showImplicitArguments = true,
        autoImportBuild = "all",
        fallbackScalaVersion = "2.12.20",
        inlayHints = {
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = true },
          implicitConversions = { enable = true },
          inferredTypes = { enable = true },
          typeParameters = { enable = true },
        },
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        testUserInterface = "Test Explorer",
        scalafmtConfigPath = home .. "/.scalafmt.conf",
        scalafixConfigPath = home .. "/.scalafix.conf",
      }

      metals_config.init_options.statusBarProvider = "off"

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
        map("n", "gt", function()
          require('telescope.builtin').lsp_type_definitions({ jump_type = 'vsplit' })
        end)
        map("n", "gD", vim.lsp.buf.declaration)
        map("n", "gi", function()
          require('telescope.builtin').lsp_implementations({ jump_type = 'vsplit' })
        end)
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
          require('telescope.builtin').lsp_dynamic_workplace_symbols()
        end)
        map("n", "<leader>gd", function()
          require('telescope.builtin').diagnostics()
        end)
        map("n", "<leader>ff", function() vim.lsp.buf.format({ async = true }) end)
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
        map("n", "<leader>qf", vim.diagnostic.setqflist)

        -- all workspace errors
        map("n", "<leader>qfe", function()
          vim.diagnostic.setqflist({ severity = "ERROR" })
        end)

        -- all workspace warnings
        map("n", "<leader>qfw", function()
          vim.diagnostic.setqflist({ severity = "WARN" })
        end)

        -- buffer diagnostics only
        map("n", "<leader>d", vim.diagnostic.setloclist)
      end

      return metals_config
    end,

    config = function(self, opts)
      local metals = require("metals")
      local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)

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

}
