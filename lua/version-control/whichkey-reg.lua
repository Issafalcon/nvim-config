local wkOpts = require("utils.whichkey-plugin")
local wk = require("which-key")

wk.register(
  {
    ["<leader>"] = {
      g = {
        name = "+Git",
        b = "Git blame line (virtual)",
        m = "Git Messenger Popup",
      },
    },
    ["["] = {
      c = "Previous Git Hunk"
    },
    ["]"] = {
      c = "Next Git Hunk"
    },
    ["lg"] = "Lazygit"
  },
  wkOpts.defaultOpts
)
