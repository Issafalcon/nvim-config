-- https://github.com/kelly-lin/ranger.nvim
if vim.fn.executable("ranger") == 1 then
  local ranger_keys = {
    {
      "n",
      "-",
      function()
        require("ranger-nvim").open(true)
      end,
      { desc = "Toggle ranger" },
    },
  }

  local ranger_nvim = require("ranger-nvim")
  ranger_nvim.setup({
    enable_cmds = false,
    replace_netrw = false,
    keybinds = {
      ["<C-v>"] = ranger_nvim.OPEN_MODE.vsplit,
      ["<C-x>"] = ranger_nvim.OPEN_MODE.split,
      ["<C-i>"] = ranger_nvim.OPEN_MODE.tabedit,
      ["<C-r>"] = ranger_nvim.OPEN_MODE.rifle,
    },
    ui = {
      border = "none",
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },
  })

  fignvim.mappings.create_keymaps(ranger_keys)
end
