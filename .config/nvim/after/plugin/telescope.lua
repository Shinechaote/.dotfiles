local builtin = require('telescope.builtin')

-- Function to find files with depth 1
function find_files_depth_1()
  require('telescope.builtin').find_files({
    find_command = { "fdfind", "--max-depth", "1" }
  })
end

vim.keymap.set('n', '<C-t>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>pf', builtin.git_files, { desc = 'Git find files' })
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep >") });
end)


vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>lua find_files_depth_1()<CR>', { noremap = true, silent = true })
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
