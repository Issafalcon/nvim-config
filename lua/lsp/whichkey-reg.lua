local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      g = {
        name = "+Go to",
        i = "Implementation",
      },
      e = "Show line diagnostics"
    },
    g = {
      D = "Go to declaration",
      d = "Go to definition"
    }
  },
  wkOpts.defaultOpts
)
