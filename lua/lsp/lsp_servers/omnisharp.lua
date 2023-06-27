M = {}
local cmd

if vim.fn.has("win32") == 1 then
  cmd = { "cmd.exe", "/C", "omnisharp" }
else
  cmd = {
    fignvim.path.concat({ vim.fn.stdpath("data"), "mason", "packages", "omnisharp", "omnisharp" }),
  }
end

M.opts = {
  cmd = cmd,
}

local extended_definitions_ok, extended_definitions = pcall(require, "omnisharp_extended")
-- local neosharper = fignvim.plug.load_module_file("neosharper")

if extended_definitions then M.opts.handlers = {
  ["textDocument/definition"] = extended_definitions.handler,
} end

-- if neosharper then
--   M.opts.on_attach = function(client, bufnr)
--     neosharper.on_attach(client, bufnr)
--   end
-- end

return M
