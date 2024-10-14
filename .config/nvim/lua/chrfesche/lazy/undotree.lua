require("chrfesche.remap")
return {
    "mbbill/undotree",

    config = function() 
        vim.keymap.set("n", keymaps.undotree_toggle, vim.cmd.UndotreeToggle)
    end
}


