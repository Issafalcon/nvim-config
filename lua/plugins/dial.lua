-- Better increment / decrement
local dial_keys = {
  { "n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" } },
  { "n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" } },
}

return {
  {
    "monaqa/dial.nvim",
    keys = fignvim.mappings.make_lazy_keymaps(dial_keys, true),
    config = function()
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
    end,
  },
}
