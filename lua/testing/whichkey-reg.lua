local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      u = {
        name = "+Ultest",
        s = "Ultest Summary Toggle",
        f = "Ultest Run Tests in File",
        n = "Ultest Run Nearest",
        c = "Ultest Clear",
        o = "Ultest Jump to output",
        ["[u"] = "Go to previous failed test",
        ["]u"] = "Go to next failed test"
      }
    }
  },
  wkOpts.defaultOpts
)
