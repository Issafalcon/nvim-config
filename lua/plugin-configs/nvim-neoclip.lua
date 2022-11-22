local neoclip = fignvim.plug.load_module_file("neoclip")
if not neoclip then
  return
end

neoclip.setup({
  history = 1000,
  enable_persistent_history = true,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
})
