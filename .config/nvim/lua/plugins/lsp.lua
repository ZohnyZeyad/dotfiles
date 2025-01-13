return {
  "neovim/nvim-lspconfig",
  name = "lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      'williamboman/mason.nvim',
      config = true,
      build = function()
        pcall(vim.api.nvim_cmd, 'MasonUpdate')
      end,
    },
    'williamboman/mason-lspconfig.nvim',
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      build = function()
        pcall(vim.api.nvim_cmd, 'MasonToolsUpdate')
      end
    },
    'saghen/blink.cmp',
    'netmute/ctags-lsp.nvim',
    {
      'folke/lazydev.nvim',
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
        enabled = true,
      },
    },
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    require('mason').setup()
    require('mason-tool-installer').setup {
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
        'stylua',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'jsonlint',
        'sql-formatter',
        'terraform-ls',
      }
    }
    vim.api.nvim_command('MasonToolsInstall')

    require('spring_boot').init_lsp_commands()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          relativePatternSupport = true,
        },
      },
    })

    require('mason-lspconfig').setup({
      automatic_installation = true,
      ensure_installed = {
        'lua_ls',
        'jdtls',
        'yamlls',
      },

      handlers = {
        function(server_name)
          if server_name ~= 'jdtls' then
            require('lspconfig')[server_name].setup {
              capabilities = capabilities
            }
          end
        end,
      }
    })

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

    local supported_filetypes = {
      "ansible", -- for AnsiblePlaybook
      "bibtex",  -- combines BibLaTeX and BibTeX
      "cs",      -- for C#
      "dbus",    -- for DBusIntrospect
      "lisp",    -- for EmacsLisp
      "ini",     -- for Iniconf
      "tcl",     -- for ITcl
      "ld",      -- for LdScript
      "maven",   -- for Maven2
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
      "rmarkdown", "robot", "rspec", "ruby", "rust", "scheme", "scss", "sh", "slang", "sml",
      "sql", "svg", "systemtap", "systemverilog", "tcl", "tex", "thrift", "toml",
      "ttcn", "typescript", "v", "varlink", "vera", "verilog", "vhdl", "vim", "windres", "xml",
      "xrc", "xslt", "yacc", "yumrepo", "zephir", "zsh",
      -- "java",
      -- "lua",
      -- "yaml",
      -- "terraform",
    }

    lspconfig.ctags_lsp.setup({
      filetypes = supported_filetypes
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      severity_sort = true,
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
