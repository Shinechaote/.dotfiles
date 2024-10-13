vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local pattern = [[\v['"`({[< ]@<=([a-zA-Z0-9])|^([a-zA-Z0-9])|(.)$|([][(){}<>.,;_+-])@<=([a-zA-Z0-9])|(['"])@<=([][(){}<>.,;_+-\$])(['"])]]
vim.keymap.set({'n', 'v'}, 'w', function()
  vim.fn.search(pattern)
end)
vim.keymap.set({'n', 'v'}, 'b', function()
    --(word) backwards
  vim.fn.search(pattern, 'b')
end)
