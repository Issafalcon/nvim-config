-- Get all the required Fignvim API functions and commands required for setup
for _, source in ipairs({
  "rocks",
  "api",
  "lsp",
  "core",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

if vim.fn.isdirectory(vim.fn.expand("$PROJECTS/neosharper.nvim")) == 1 then
  fignvim.module.register_plugins({
    "neosharper",
  })
end

if vim.fn.has("win32") == 1 then
  fignvim.config.set_shell_as_powershell()
end

if vim.fn.has("wsl") == 1 then
  fignvim.config.set_win32yank_wsl_as_clip()
end

fignvim.plug.initialize_rocks_nvim()

-- 6. Create mappings
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true }) -- Prep for space to be leader key
fignvim.mappings.create_core_mappings()
