require("chrfesche.remap")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
  callback = function(event)
    local opts = {buffer = event.buf}
    

    vim.keymap.set('n', keymaps.lsp_definition, function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', keymaps.lsp_hover, function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', keymaps.lsp_workspace_symbol, function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', keymaps.lsp_diagnostic_open_float, function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', keymaps.lsp_diagnostic_goto_next, function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', keymaps.lsp_diagnostic_goto_previous, function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', keymaps.lsp_buf_code_action, function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', keymaps.lsp_buf_references, function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', keymaps.lsp_buf_rename, function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', keymaps.lsp_buf_signature_help, function() vim.lsp.buf.signature_help() end, opts)
  end,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'pylsp'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = lsp_capabilities,
      })
    end,
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = {'vim'},
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              }
            }
          }
        }
      })
    end,
  }
})

require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false }, -- Disables pycodestyle linting
                pyflakes = { enabled = false },    -- Disables pyflakes linting
                pylint = { enabled = false },      -- Disables pylint linting (if enabled)
                flake8 = { enabled = false },      -- Disables flake8 (if installed and enabled)
                mccabe = { enabled = false },      -- Disables mccabe complexity checker
                -- Add any other linters or plugins you want to disable here
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},  
    {name = 'luasnip'},  
  }, {
    {name = 'buffer'},
  }),
  mapping = cmp.mapping.preset.insert({
    [keymaps.lsp_select_prev_item] = cmp.mapping.select_prev_item(cmp_select),
    [keymaps.lsp_select_next_item] = cmp.mapping.select_next_item(cmp_select),
    [keymaps.lsp_confirm] = cmp.mapping.confirm({select = true}),
    [keymaps.lsp_complete] = cmp.mapping.complete(),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
