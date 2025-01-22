local dial_keys = {
  {
    "n",
    "<C-a>",
    function()
      return require("dial.map").inc_normal()
    end,
    { expr = true, desc = "Increment" },
  },
  {
    "n",
    "<C-s>",
    function()
      return require("dial.map").dec_normal()
    end,
    { expr = true, desc = "Decrement" },
  },
}

-- Better increment / decrement
-- https://github.com/monaqa/dial.nvim
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

fignvim.mappings.create_keymaps(dial_keys)
