require("chrfesche.remap")

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    { keymaps.flash_search, mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { keymaps.flash_treesitter, mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { keymaps.flash_treesitter_search, mode = {"n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { keymaps.flash_toggle_search, mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
