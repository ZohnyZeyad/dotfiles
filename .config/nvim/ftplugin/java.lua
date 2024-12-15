local _, conf_opts = pcall(require, "plugins.lsp.settings.jdtls")

require('jdtls').start_or_attach(conf_opts.get_config())
