local rnvimr_keys = {
  { "n", "-", ":RnvimrToggle<CR>", { desc = "Rnvimr: Toggle Rnvimr" } },
}

return {
  {
  "kevinhwang91/rnvimr",
  cmd = "RnvimrToggle",
  -- TODO: Remove commit pin once issue with mouse support fixed
  commit = "5edff6189cb0f4fae77ee751de5109a8f87cb9c7",
  init = function()
    fignvim.config.set_vim_opts({
      g = {
        rnvimr_enable_ex = 0, -- Replace netrw with ranger
        rnvimr_draw_border = 1, -- Draw border for ranger
        rnvimr_enable_picker = 1, -- Keep showing ranger after choosing a file
        rnvimr_edit_cmd = "edit", -- Edit file in current window
        rnvimr_enable_bw = 1, -- Make nvim wipe buffers corresponding to files deleted in Ranger
        rnvimr_border_attr = { fg = 14, bg = -1 }, -- Ranger border colour
        rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" },
        rnvimr_action = {
          ["<C-i>"] = "NvimEdit tabedit",
          ["<C-x>"] = "NvimEdit split",
          ["<C-v>"] = "NvimEdit vsplit",
          ["gw"] = "JumpNvimCwd",
          ["yw"] = "EmitRangerCwd",
        }, -- Ranger keybindings
      },
    })
  end,
  enabled = function() return vim.fn.executable("ranger") == 1 end,
  keys = fignvim.mappings.make_lazy_keymaps(rnvimr_keys, true),
}
}