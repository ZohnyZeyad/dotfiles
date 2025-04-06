local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities(),
  {
    workspace = {
      didChangeWatchedFiles = {
        relativePatternSupport = true,
      },
    },
  }
)

return {
  "neovim/nvim-lspconfig",
  name = "lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {

    {
      'nvim-java/nvim-java',
      enabled = false,
    },

    {
      'williamboman/mason.nvim',
      lazy = true,

      build = function()
        pcall(vim.api.nvim_cmd, 'MasonUpdate')
      end,

      opts = {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      },
    },

    {
      'williamboman/mason-lspconfig.nvim',
      lazy = true,
      dependencies = { "williamboman/mason.nvim" },

      config = function()
        require('mason-lspconfig').setup({
          automatic_installation = true,
          ensure_installed = {
            'lua_ls',
            'yamlls',
            'jdtls',
            'marksman',
          },

          handlers = {
            function(server_name)
              if server_name == 'yamlls' then
                require('lspconfig')[server_name].setup {
                  capabilities = vim.tbl_deep_extend("force", {},
                    capabilities,
                    {
                      textDocument = {
                        foldingRange = {
                          dynamicRegistration = false,
                          lineFoldingOnly = true,
                        },
                      },
                    })
                }
              elseif server_name ~= 'jdtls' then
                require('lspconfig')[server_name].setup {
                  capabilities = capabilities
                }
              end
            end,
          }
        })
      end,
    },

    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      lazy = true,

      build = function()
        pcall(vim.api.nvim_cmd, 'MasonToolsUpdate')
      end,

      config = function()
        require('mason-tool-installer').setup {
          ensure_installed = {
            'shfmt',
            'java-debug-adapter',
            'java-test',
            'stylua',
            'docker-compose-language-service',
            'dockerfile-language-server',
            'jsonlint',
            'sql-formatter',
            'terraform-ls',
            'markdownlint-cli2',
            'markdown-toc',
            'tflint',
            'bashls',
            'shellcheck',
          }
        }

        vim.api.nvim_command('MasonToolsInstall')
      end,
    },

    'saghen/blink.cmp',
    -- 'netmute/ctags-lsp.nvim',

    {
      'folke/lazydev.nvim',
      ft = "lua",

      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { "nvim-dap-ui" },
        },
        enabled = true,
      },
    },

    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    local lspconfig = require('lspconfig')

    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = { version = "Lua 5.1" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          }
        }
      }
    }

    -- require('java').setup({
    --   jdk = { -- install jdk using mason.nvim
    --     auto_install = false,
    --     version = '21.0.6',
    --   },
    --   jdtls = {
    --     version = 'v1.43.0',
    --   },
    --   java_debug_adapter = {
    --     enable = true,
    --     version = '0.58.1',
    --   },
    --   java_test = {
    --     enable = true,
    --     version = '0.43.0',
    --   },
    --   spring_boot_tools = {
    --     enable = true,
    --     version = '1.59.0',
    --   },
    -- })
    --
    -- require('spring_boot').init_lsp_commands()
    --
    -- local home = vim.env.HOME
    -- require("lspconfig").jdtls.setup {
    --   -- Here you can configure eclipse.jdt.ls specific settings
    --   ---@see https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    --   settings = {
    --     java = {
    --       eclipse = {
    --         downloadSources = true,
    --       },
    --       maven = {
    --         downloadSources = true,
    --         updateSnapshots = true,
    --       },
    --       implementationsCodeLens = { enabled = true },
    --       referencesCodeLens = { enabled = true },
    --       references = { includeDecompiledSources = true },
    --       inlayHints = {
    --         parameterNames = {
    --           enabled = "all", -- literals, all, none
    --         },
    --       },
    --       signatureHelp = { enabled = true },
    --       saveActions = { organizeImports = true },
    --       contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
    --       configuration = {
    --         updateBuildConfiguration = "interactive",
    --         -- The runtime name parameters need to match specific Java execution environments.
    --         ---@see https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
    --         runtimes = {
    --           {
    --             name = "JavaSE-11",
    --             path = home .. "/.sdkman/candidates/java/11.0.26-amzn/",
    --             javadoc = "https://docs.oracle.com/en/java/javase/11/docs/api/",
    --             default = true,
    --           },
    --           {
    --             name = "JavaSE-17",
    --             path = home .. "/.sdkman/candidates/java/17.0.14-amzn/",
    --             javadoc = "https://docs.oracle.com/en/java/javase/17/docs/api/",
    --           },
    --           {
    --             name = "JavaSE-21",
    --             path = home .. "/.sdkman/candidates/java/21.0.6-amzn/",
    --             javadoc = "https://docs.oracle.com/en/java/javase/21/docs/api/",
    --           },
    --         },
    --       },
    --       format = {
    --         enabled = true,
    --         -- Formatting works by default, but you can refer to a specific file/URL if you choose
    --         settings = {
    --           -- url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
    --           -- profile = "GoogleStyle",
    --           --
    --           -- url = "https://github.com/ZohnyZeyad/dotfiles/blob/main/.config/code/checkstyle.xml",
    --           -- url = home .. "/Documents/Nix/checkstyle.xml",
    --           -- profile = "NixCheckStyle",
    --           --
    --           url = home .. "/Documents/RTA/Analytics_Java_Style.xml",
    --           profile = "RtaJavaStyle",
    --           --
    --           --   url = home .. "/Documents/RTA/Analytics_Scala_Style.xml",
    --           --   profile = "RtaScalaStyle",
    --         },
    --       },
    --       import = {
    --         gradle = {
    --           enabled = true,
    --         },
    --         maven = {
    --           enabled = true,
    --         },
    --         exclusions = {
    --           "**/node_modules/**",
    --           "**/.metadata/**",
    --           "**/archetype-resources/**",
    --           "**/META-INF/maven/**",
    --           "/**/test/**"
    --         },
    --       },
    --       completion = {
    --         favoriteStaticMembers = {
    --           "org.hamcrest.MatcherAssert.assertThat",
    --           "org.hamcrest.Matchers.*",
    --           "org.hamcrest.CoreMatchers.*",
    --           "org.junit.jupiter.api.Assertions.*",
    --           "java.util.Objects.requireNonNull",
    --           "java.util.Objects.requireNonNullElse",
    --           "org.mockito.Mockito.*",
    --         },
    --         importOrder = {
    --           "com",
    --           "org",
    --           "jakarta",
    --           "javax",
    --           "java",
    --         },
    --       },
    --       sources = {
    --         organizeImports = {
    --           starThreshold = 9999,
    --           staticStarThreshold = 9999,
    --         },
    --       },
    --       codeGeneration = {
    --         toString = {
    --           template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
    --         },
    --         hashCodeEquals = {
    --           useJava7Objects = false,
    --           useInstanceOf = true,
    --         },
    --         useBlocks = true,
    --         addFinalForNewDeclaration = "fields",
    --       },
    --       -- extendedClientCapabilities = extendedClientCapabilities,
    --     },
    --   },
    --
    --   capabilities = capabilities, -- Needed for auto-completion with method signatures and placeholders
    --   flags = {
    --     debounce_text_changes = 80,
    --     allow_incremental_sync = true,
    --   },
    --
    --   init_options = {
    --     bundles = require("spring_boot").java_extensions(),
    --   },
    --
    --   handlers = {
    --     -- By assigning an empty function, you can remove the notifications
    --     -- printed to the cmd
    --     -- ["$/progress"] = function(_, result, ctx) end,
    --   },
    -- }

    ---@diagnostic disable-next-line: unused-local
    local supported_filetypes = {
      "ansible", -- for AnsiblePlaybook
      "bibtex",  -- combines BibLaTeX and BibTeX
      "cs",      -- for C#
      "dbus",    -- for DBusIntrospect
      "lisp",    -- for EmacsLisp
      "ini",     -- for Iniconf
      "tcl",     -- for ITcl
      "ld",      -- for LdScript
      "objc",    -- for ObjectiveC
      "plist",   -- for PlistXML
      "puppet",  -- for PuppetManifest
      "qemu",    -- for QemuHX
      "qt",      -- for QtMoc
      "rng",     -- for RelaxNG
      "rst",     -- for ReStructuredText
      "rpm",     -- for RpmSpec
      "systemd", -- for SystemdUnit
      "abaqus", "abc", "ada", "ant", "asciidoc", "asm", "asp", "autoconf", "autoit",
      "automake", "awk", "basic", "bats", "beta", "c", "cpp", "cargo", "clojure",
      "cmake", "cobol", "css", "cuda", "d", "diff", "dosbatch", "dtd", "dts", "eiffel",
      "elixir", "elm", "erlang", "falcon", "flex", "forth", "fortran", "fypp", "gdscript",
      "gemspec", "glade", "go", "gperf", "haskell", "haxe", "html", "inko",
      "javascript", "json", "julia", "kconfig", "kotlin", "lex", "lisp",
      "m4", "make", "man", "markdown", "matlab", "meson", "moose", "myrddin", "nsis",
      "ocaml", "openapi", "org", "pascal", "passwd", "perl", "php", "pkgconfig", "pod",
      "powershell", "protobuf", "python", "quarto", "r", "rake", "raku", "rdoc", "rexx",
      "rmarkdown", "robot", "rspec", "ruby", "rust", "scheme", "scss", "slang", "sml",
      "sql", "svg", "systemtap", "systemverilog", "tcl", "tex", "thrift", "toml",
      "ttcn", "typescript", "v", "varlink", "vera", "verilog", "vhdl", "vim", "windres",
      "xrc", "xslt", "yacc", "yumrepo", "zephir", "zsh",
      -- "sh",
      -- "maven",
      -- "xml",
      -- "java",
      -- "lua",
      -- "yaml",
      -- "terraform",
    }

    -- lspconfig.ctags_lsp.setup({
    --   filetypes = supported_filetypes
    -- })

    vim.diagnostic.config({
      -- update_in_insert = true,
      virtual_lines = { current_line = false },
      severity_sort = true,
      jump = { float = false },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      {
        focus = true,
        border = "rounded",
      }
    )

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      {
        focus = false,
        border = "rounded",
      }
    )

    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
      })
    end

    sign({ name = 'DiagnosticSignError', text = '✘' })
    sign({ name = 'DiagnosticSignWarn', text = '▲' })
    sign({ name = 'DiagnosticSignHint', text = '⚑' })
    sign({ name = 'DiagnosticSignInfo', text = '»' })
  end
}
