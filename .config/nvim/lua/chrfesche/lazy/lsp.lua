require("chrfesche.remap")
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },


    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())


        -- Function for LSP keymaps
        local on_attach = function()
            local opts = {remap = false }

            -- Key mappings for LSP features
            vim.keymap.set("n", keymaps.lsp_definition, function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", keymaps.lsp_hover, function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", keymaps.lsp_workspace_symbol, function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_open_float, function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_goto_next, function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_goto_previous, function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", keymaps.lsp_buf_code_action, function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", keymaps.lsp_buf_references, function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", keymaps.lsp_buf_rename, function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", keymaps.lsp_buf_signature_help, function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", keymaps.lsp_buf_signature_help, function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set('n', keymaps.lsp_format, function() vim.lsp.buf.format() end,opts)
        end
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pylsp",
                "html",
                "cssls"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                    on_attach()
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                    on_attach()
                end,
                ["pylsp"] = function()
                    require('lspconfig').pylsp.setup({
                        capabilities = capabilities,
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = { enabled = false },
                                    pyflakes = { enabled = false },
                                    pylint = { enabled = false },
                                    flake8 = { enabled = false },
                                    mccabe = { enabled = false },
                                    yapf = { enabled = false },
                                    black = { enabled = true },
                                    -- Add any other linters or plugins you want to disable here
                                }
                            }
                        }
                    })
                    on_attach()
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                [keymaps.lsp_select_prev_item] = cmp.mapping.select_prev_item(cmp_select),
                [keymaps.lsp_select_next_item] = cmp.mapping.select_next_item(cmp_select),
                [keymaps.lsp_confirm] = cmp.mapping.confirm({ select = true }),
                [keymaps.lsp_complete] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
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
