vim.g.mapleader = " "

-- File explorer
vim.keymap.set("n", "<leader>w", vim.cmd.Ex)
-- Paste without changing buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

local pattern = [[\v['"`({[< ]@<=([a-zA-Z0-9])|^([a-zA-Z0-9])|(.)$|([][(){}<>/.,;_=+-])@<=([a-zA-Z0-9])|(['"])@<=([][(){}<>/.,;_=+-\$])(['"])]]
vim.keymap.set({'n', 'v'}, 'w', function()
  vim.fn.search(pattern)
end)
vim.keymap.set({'n', 'v'}, 'b', function()
    --(word) backwards
  vim.fn.search(pattern, 'b')
end)


_G.keymaps = {}
-- LSP
keymaps.lsp_definition = 'gd'
keymaps.lsp_hover = 'K'
keymaps.lsp_workspace_symbol = '<leader>vws'
keymaps.lsp_diagnostic_open_float = '<leader>vd'
keymaps.lsp_diagnostic_goto_next = '[d'
keymaps.lsp_diagnostic_goto_previous = ']d'
keymaps.lsp_buf_code_action = '<leader>vca'
keymaps.lsp_buf_references = '<leader>vrr'
keymaps.lsp_buf_rename = '<leader>vrn'
keymaps.lsp_buf_signature_help = '<C-b>'

keymaps.lsp_select_prev_item = '<C-t>'
keymaps.lsp_select_next_item = '<C-n>'
keymaps.lsp_confirm = '<C-i>'
keymaps.lsp_complete = '<C-Space>'
keymaps.lsp_format = "<leader>f"

-- Harpoon
keymaps.harpoon_add_file = "<leader>a"
keymaps.harpoon_toggle_quick_menu = "<C-e>"
keymaps.harpoon_nav_file_1 = "<C-n>"
keymaps.harpoon_nav_file_2 = "<C-h>"
keymaps.harpoon_nav_file_3 = "<C-l>"

-- Fugitive
keymaps.fugitive_git = "<leader>gs"
keymaps.fugitive_push = "<leader>p"
keymaps.fugitive_primeagen_push_hack = "<leader>p"
keymaps.fugitive_rebase_pull = "<leader>P"
keymaps.fugitive_primeagen_push_hack = "<leader>t"
keymaps.fugitive_primeagen_diffget_2 = "gu"
keymaps.fugitive_primeagen_diffget_3 = "gh"

-- Undotree
keymaps.undotree_toggle = "<leader>u"

-- Telescope
keymaps.telescope_find_files = "<C-t>"
keymaps.telescope_git_files = "<leader>pf"
keymaps.telescope_grep_string = "<leader>ps"
keymaps.telescope_find_depth_4 = "<C-p>"

-- Commenter
keymaps.comment_toggle = "<leader>c"
