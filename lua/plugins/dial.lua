vim.pack.add({
  { src = "https://github.com/monaqa/dial.nvim" },
})

local augend = require("dial.augend")

require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.alias.bool,
    augend.semver.alias.semver,
  },
})

vim.keymap.set("n", "<C-a>", function()
  return require("dial.map").inc_normal()
end, { expr = true, desc = "Increment" })
vim.keymap.set("n", "<C-x>", function()
  return require("dial.map").dec_normal()
end, { expr = true, desc = "Decrement" })
