local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      ["1"] = "Open Buffer Line 1",
      ["2"] = "Open Buffer Line 2",
      ["3"] = "Open Buffer Line 3",
      ["4"] = "Open Buffer Line 4",
      ["5"] = "Open Buffer Line 5",
      ["6"] = "Open Buffer Line 6",
      ["7"] = "Open Buffer Line 7",
      ["8"] = "Open Buffer Line 8",
      ["9"] = "Open Buffer Line 9",
    },
  },
  wkOpts.defaultOpts
)
