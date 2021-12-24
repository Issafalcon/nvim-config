local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      s = {
        name = "+Search",
        s = "String (prompt)",
        w = "String (under cursor)",
        l = "Custom Live Grep",
        f = "File (all files)",
        b = "Buffer list",
        h = "Help tags",
        c = "Config files",
        gc = "Git commits",
        gb = "Git branches",
        gs = "Git status",
        t = "Colour schemes"
      },
    }
  },
  wkOpts.defaultOpts
)
