local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      g = {
        name = "+Go to",
        i = "Implementation",
      },
      e = "Show line diagnostics",
      t = {
        name = "+TS LSP Extensions",
        o = "Organize Imports",
        i = "Import All",
        ["rn"] = "Rename TS File",
      }
    },
    g = {
      D = "Go to declaration",
      d = "Go to definition"
    }
  },
  wkOpts.defaultOpts
)
