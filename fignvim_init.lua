local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

for _, source in ipairs({
  "api",
  "api.lsp",
  "commands.autocommands",
  "commands.usercommands",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

if vim.fn.has("nvim-0.8") ~= 1 or vim.version().prerelease then
  vim.schedule(
    function() --[[ fignvim.ui.notify("Unsupported Neovim Version! Please check the requirements", "error" )]]
    end
  )
end
local mappings = fignvim.config.get_config("mappings")

for group, group_mappings in pairs(mappings.general_mappings) do
  fignvim.config.create_mapping_group(group_mappings, group)
end
