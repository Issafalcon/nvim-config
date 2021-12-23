local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      t = {
        name = "+Theme",
        m = "Material Theme Toggle",
      }
    }
  },
  wkOpts.defaultOpts
)
