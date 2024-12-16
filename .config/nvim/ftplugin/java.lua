-- JDTLS (Java LSP) configuration
local home = vim.env.HOME

local jdtls = require("jdtls")

local java_path = os.getenv 'JAVA_HOME'
local java = java_path .. "/bin/java"

local root_markers = {
  'settings.gradle',
  'settings.gradle.kts',
  'pom.xml',
  'build.gradle',
  'mvnw',
  'gradlew',
  'build.gradle',
  'build.gradle.kts',
  '.git',
}

local root_dir = require("jdtls.setup").find_root(root_markers)

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local system_os = ""

-- Determine OS
if vim.fn.has("mac") == 1 then
  system_os = "mac"
elseif vim.fn.has("unix") == 1 then
  system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  system_os = "win"
else
  print("OS not found, defaulting to 'linux'")
  system_os = "linux"
end

-- Needed for debugging
local bundles = {
  vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))
vim.list_extend(bundles, require("spring_boot").java_extensions())

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    java,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
    "-Xms4g",
    "-Xmx8g",
    -- '-XX:+UseG1GC',
    -- '-XX:+UseCompressedOops',
    -- '-XX:ConcGCThreads=4',
    -- '-XX:+UseStringDeduplication',
    -- '-ea',
    -- '-XX:CICompilerCount=2',
    -- '-XX:+HeapDumpOnOutOfMemoryError',
    -- '-XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log',
    -- '-XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof',
    -- '-XX:-OmitStackTraceInFastThrow',
    -- '-XX:ReservedCodeCacheSize=512m',
    -- '-XX:+ParallelRefProcEnabled',
    -- '-XX:SoftRefLRUPolicyMSPerMB=1000',
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    -- Eclipse jdtls location
    "-jar",
    home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. system_os,
    "-data",
    workspace_dir,
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  -- root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      home = java_path,
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
        -- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
        -- runtimes = {
        --   {
        --     name = "JavaSE-11",
        --     path = "/usr/lib/jvm/java-11-openjdk-amd64",
        --   },
        --   {
        --     name = "JavaSE-17",
        --     path = "/usr/lib/jvm/java-17-openjdk-amd64",
        --   },
        --   {
        --     name = "JavaSE-19",
        --     path = "/usr/lib/jvm/java-19-openjdk-amd64",
        --   },
        -- },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
      format = {
        enabled = true,
        -- Formatting works by default, but you can refer to a specific file/URL if you choose
        settings = {
          -- url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
          -- profile = "GoogleStyle",
          --
          -- url = "https://github.com/ZohnyZeyad/dotfiles/blob/main/.config/code/checkstyle.xml",
          -- url = home .. "/Documents/EDU/checkstyle.xml",
          -- profile = "NixCheckStyle",
          --
          url = home .. "/Documents/RTA/Analytics_Java_Style.xml",
          profile = "RtaJavaStyle",
          --
          --   url = home .. "/Documents/RTA/Analytics_Scala_Style.xml",
          --   profile = "RtaScalaStyle",
        },
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = {
          "java",
          "javax",
          "jakarta",
          "com",
          "org",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },
  -- Needed for auto-completion with method signatures and placeholders
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {
    debounce_text_changes = 80,
    allow_incremental_sync = true,
  },
  init_options = {
    -- References the bundles defined above to support Debugging and Unit Testing
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- Needed for debugging
config["on_attach"] = function(_, _)
  jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()
end

config["on_init"] = function(client, _)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
-- vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
-- vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
--   { desc = 'Extract Variable' })
-- vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
-- vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
--   { desc = 'Extract Constant' })
-- vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
