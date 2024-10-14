require("chrfesche.remap")

return {
    "ThePrimeagen/harpoon",
    config = function()

        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", keymaps.harpoon_add_file, mark.add_file)
        vim.keymap.set("n", keymaps.harpoon_toggle_quick_menu, ui.toggle_quick_menu)

        vim.keymap.set("n", keymaps.harpoon_nav_file_1, function() ui.nav_file(1) end)
        vim.keymap.set("n", keymaps.harpoon_nav_file_2, function() ui.nav_file(2) end)
        vim.keymap.set("n", keymaps.harpoon_nav_file_3, function() ui.nav_file(3) end)
    end
}
