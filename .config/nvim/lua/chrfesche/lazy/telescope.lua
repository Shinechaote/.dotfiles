require("chrfesche.remap")


return {
    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    dependencies = {
        {"nvim-lua/plenary.nvim"},
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
    },

    config = function()

        require('telescope').setup {
            pickers = {
                find_files = {
                    hidden=true,
                }
            },
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
        local builtin = require('telescope.builtin')

        -- Function to find files with depth 2
        function find_files_depth_4()
        require('telescope.builtin').find_files({
            find_command = { "fdfind", "--max-depth", "4" }
        })
    end

    vim.keymap.set('n', keymaps.telescope_find_files, builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', keymaps.telescope_git_files, builtin.git_files, { desc = 'Git find files' })
    vim.keymap.set('n', keymaps.telescope_grep_string, function()
        builtin.grep_string({ search = vim.fn.input("Grep >") });
    end)


    vim.api.nvim_set_keymap('n', keymaps.telescope_find_depth_4, '<cmd>lua find_files_depth_4()<CR>', { noremap = true, silent = true })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')

end
}


