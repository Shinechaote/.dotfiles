vim.opt.nu = true
vim.opt.relativenumber = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.iskeyword:remove("_")

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        local path = vim.fn.expand("%:p:h")  -- Get the full path to the directory of the current file
        if vim.fn.isdirectory(path) == 1 then
            vim.cmd("cd " .. path)           -- Change the working directory
        end
    end,
})
