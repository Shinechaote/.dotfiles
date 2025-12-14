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

        -- 1. Setup Mason & Fidget
        require("mason").setup()
        require("fidget").setup({})

        -- Only used to ensure binaries are downloaded. 
        -- We no longer use the 'handlers' block here.
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "pylsp", "html", "cssls",
            },
        })

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- 2. LspAttach Autocommand (Unchanged)
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, remap = false }
                -- Assuming 'keymaps' is your global variable
                vim.keymap.set("n", keymaps.lsp_definition, vim.lsp.buf.definition, opts)
                vim.keymap.set("n", keymaps.lsp_hover, vim.lsp.buf.hover, opts)
                vim.keymap.set("n", keymaps.lsp_workspace_symbol, vim.lsp.buf.workspace_symbol, opts)
                vim.keymap.set("n", keymaps.lsp_diagnostic_open_float, vim.diagnostic.open_float, opts)
                vim.keymap.set("n", keymaps.lsp_diagnostic_goto_next, vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", keymaps.lsp_diagnostic_goto_previous, vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", keymaps.lsp_buf_code_action, vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", keymaps.lsp_buf_references, vim.lsp.buf.references, opts)
                -- vim.keymap.set("n", keymaps.lsp_buf_rename, vim.lsp.buf.rename, opts)
                vim.keymap.set("n", keymaps.lsp_buf_rename, function()
                    -- 1. Save the current "word" definition
                    local original_iskeyword = vim.bo.iskeyword

                    -- 2. Temporarily add '_' to the definition so LSP grabs the full variable
                    vim.bo.iskeyword = original_iskeyword .. ",_"

                    -- 3. Trigger the rename (Neovim reads the word immediately here)
                    vim.lsp.buf.rename()

                    -- 4. Immediately restore the definition so 'e' and 'w' go back to normal
                    vim.bo.iskeyword = original_iskeyword
                end, opts)
                vim.keymap.set("i", keymaps.lsp_buf_signature_help, vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", keymaps.lsp_buf_signature_help, vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", keymaps.lsp_format, function() 
                    vim.lsp.buf.format({ async = true }) 
                end, opts)
            end,
        })

        -- 3. Configure Servers using new vim.lsp.config syntax
        -- Note: 'cmd' works because Mason adds the bin folder to your PATH

        -- --- Lua LS ---
        vim.lsp.config['lua_ls'] = {
            capabilities = capabilities,
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                }
            }
        }

        -- --- PyLSP ---
        vim.lsp.config['pylsp'] = {
            capabilities = capabilities,
            cmd = { 'pylsp' },
            filetypes = { 'python' },
            root_markers = { 'pyproject.toml', 'setup.py', '.git', 'requirements.txt' },
            settings = {
                pylsp = {
                    plugins = {
                        black = { enabled = true },
                        yapf = { enabled = false },
                        pylint = { enabled = false },
                        pyflakes = { enabled = true },
                        pycodestyle = { enabled = false },
                        flake8 = { enabled = false },
                        mccabe = { enabled = false },
                    },
                },
            },
        }

        -- --- HTML ---
        vim.lsp.config['html'] = {
            capabilities = capabilities,
            cmd = { 'vscode-html-language-server', '--stdio' },
            filetypes = { 'html' },
            root_markers = { '.git' },
        }

        -- --- CSSLS ---
        vim.lsp.config['cssls'] = {
            capabilities = capabilities,
            cmd = { 'vscode-css-language-server', '--stdio' },
            filetypes = { 'css', 'scss', 'less' },
            root_markers = { '.git', 'package.json' },
            settings = {
                css = { validate = true },
                scss = { validate = true },
                less = { validate = true }
            },
        }

        -- Enable the servers (Required if not using the nvim-lspconfig plugin wrappers)
        -- Since you are on the "new" config, you simply enable them:
        for _, server in ipairs({ "lua_ls", "pylsp", "html", "cssls" }) do
            vim.lsp.enable(server)
        end


        -- 4. CMP Setup (Unchanged)
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
