-- Lazy load on command
vim.api.nvim_create_user_command("LuapadLoad", function(_)
  vim.pack.add({
    { src = "https://github.com/rafcamlet/nvim-luapad" },
  })

  require("luapad").setup()

  vim.keymap.set("n", "<leader>lp", function()
    require("luapad").init()
  end, { desc = "Open Luapad" })
end, { nargs = 0, desc = "Load nvim-luapad" })
