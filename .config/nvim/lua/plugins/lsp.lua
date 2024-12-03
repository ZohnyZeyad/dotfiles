return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        "williamboman/mason-lspconfig.nvim",
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "FelipeLema/cmp-async-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "petertriho/cmp-git",
        "SergioRibera/cmp-dotenv",
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
                {
                    "benfowler/telescope-luasnip.nvim",
                    module = "telescope._extensions.luasnip",
                },
            },
        },
        { 'j-hui/fidget.nvim',       opts = {} },
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()
        require('mason-tool-installer').setup {
            ensure_installed = {
                "lua_ls",
                "stylua",
                "docker-compose-language-service",
                "dockerfile-language-server",
                "jsonlint",
                "sql-formatter",
                "terraform-ls",
            }
        }
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip").filetype_extend("java", { "javadoc", "java-tests" })
        require("luasnip").filetype_extend("scala", { "javadoc" })
        require("luasnip").filetype_extend("sh", { "shelldoc" })
        require("luasnip").filetype_extend("typescript", { "tsdoc" })
        require("luasnip").filetype_extend("javascript", { "jsdoc" })

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                --[[["<Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
                ["<S-Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,]] --
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                -- { name = "nvim_lsp_signature_help" },
            }, {
                { name = 'buffer' },
                { name = 'async_path' },
                -- { name = 'path' },
            })
        })

        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' },
            }, {
                { name = 'buffer' },
            })
        })
        require("cmp_git").setup()

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "nvim_lsp_document_symbol" },
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'async_path' },
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        cmp.setup.filetype("sh", {
            sources = cmp.config.sources({
                { name = "dotenv" },
                { name = "cmdline" },
            }),
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
