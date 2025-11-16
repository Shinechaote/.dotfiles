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
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Function for LSP keymaps
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", keymaps.lsp_definition, vim.lsp.buf.definition, opts)
            vim.keymap.set("n", keymaps.lsp_hover, vim.lsp.buf.hover, opts)
            vim.keymap.set("n", keymaps.lsp_workspace_symbol, vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_open_float, vim.diagnostic.open_float, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_goto_next, vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", keymaps.lsp_diagnostic_goto_previous, vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", keymaps.lsp_buf_code_action, vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", keymaps.lsp_buf_references, vim.lsp.buf.references, opts)
            vim.keymap.set("n", keymaps.lsp_buf_rename, vim.lsp.buf.rename, opts)
            vim.keymap.set("i", keymaps.lsp_buf_signature_help, vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", keymaps.lsp_buf_signature_help, vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", keymaps.lsp_format, function() vim.lsp.buf.format({ async = true }) end, opts)
        end

        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                },
            },
        }
        )

        vim.lsp.config('pylsp', {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { enabled = false },
                        pyflakes = { enabled = true },
                        pylint = { enabled = false },
                        flake8 = { enabled = false },
                        mccabe = { enabled = false },
                        yapf = { enabled = false },
                        black = { enabled = true },
                    },
                },
            },
        }
        )

        vim.lsp.config('*', {
            capabilities = capabilities,
            on_attach = on_attach,
        }
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pylsp",
                "html",
                "cssls",
            },
        })

        -- CMP setup
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                [keymaps.lsp_select_prev_item] = cmp.mapping.select_prev_item(cmp_select),
                [keymaps.lsp_select_next_item] = cmp.mapping.select_next_item(cmp_select),
                [keymaps.lsp_confirm] = cmp.mapping.confirm({ select = true }),
                [keymaps.lsp_complete] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
        })

        -- Diagnostics config
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
