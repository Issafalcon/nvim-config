local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

-- 1. Get all the required Fignvim API functions and commands required for setup
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

-- 2. Check compatible version of Neovim
if vim.fn.has("nvim-0.8") ~= 1 or vim.version().prerelease then
  vim.schedule(
    function() --[[ fignvim.ui.notify("Unsupported Neovim Version! Please check the requirements", "error" )]]
    end
  )
end


-- 3. Initialise the plugin manager and load all plugins
fignvim.plug.initialise_packer()
fignvim.plug.setup_plugins()

-- 4. Set up some UI features
fignvim.ui.set_colourscheme()
fignvim.ui.configure_diagnostics()

-- 5. Set up the LSP servers
fignvim.lsp.setup_all_lsp_servers()

-- 6. Create the remaining general mappings
fignvim.config.set_general_mappings()
