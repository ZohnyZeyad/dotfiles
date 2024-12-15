local M = {}

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local home = os.getenv 'HOME'
local java_path = os.getenv 'JAVA_HOME'
local java = java_path .. "/bin/java"
WORKSPACE_PATH = home .. "/workspace/"
CONFIG = "linux"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = WORKSPACE_PATH .. project_name

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

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_path ..
    "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
)

M.get_config = function()
  return {
    cmd = {
      java,
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms4g',
      '-Xmx8g',
      '-XX:+UseG1GC',
      '-XX:+UseCompressedOops',
      '-XX:ConcGCThreads=4',
      '-XX:+UseStringDeduplication',
      '-ea',
      '-XX:CICompilerCount=2',
      '-XX:+HeapDumpOnOutOfMemoryError',
      '-XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log',
      '-XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof',
      '-XX:-OmitStackTraceInFastThrow',
      '-XX:ReservedCodeCacheSize=512m',
      '-XX:+ParallelRefProcEnabled',
      '-XX:SoftRefLRUPolicyMSPerMB=1000',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
      '-jar',
      vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration',
      home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
      '-data',
      workspace_dir,
    },

    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },

    handlers = {},
    root_dir = vim.fs.root(0, root_markers),
    capabilities = require("lsp.handlers").capabilities,
    contentProvider = { preferred = "fernflower" },
    on_init = on_init,
    on_attach = require("lsp.handlers").on_attach,

    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = {
      java = {
        signatureHelp = { enabled = true },
        configuration = {
          updateBuildConfiguration = "interactive",
        },
        jdk = {
          auto_install = false,
        },
        eclipse = {
          downloadSources = true,
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
  }
end

vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
-- vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
-- vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
--   { desc = 'Extract Variable' })
-- vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
-- vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
--   { desc = 'Extract Constant' })
-- vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })

return M
