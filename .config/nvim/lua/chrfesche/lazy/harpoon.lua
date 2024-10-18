require("chrfesche.remap")

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup({})

        -- basic telescope configuration
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end
        end
        vim.keymap.set("n", keymaps.harpoon_toggle_quick_menu, function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
        vim.keymap.set("n", keymaps.harpoon_add_file, function() harpoon:list():add() end)

        vim.keymap.set("n", keymaps.harpoon_nav_file_1, function() harpoon:list():select(1) end)
        vim.keymap.set("n", keymaps.harpoon_nav_file_2, function() harpoon:list():select(2) end)
        vim.keymap.set("n", keymaps.harpoon_nav_file_3, function() harpoon:list():select(3) end)
    end
}
