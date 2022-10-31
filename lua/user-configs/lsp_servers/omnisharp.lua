local path = require("utils.path")

M = {}
M.opts = {
  cmd = {
    "dotnet",
    path.concat({ vim.fn.stdpath("data"), "mason", "packages", "omnisharp", "OmniSharp.dll" }),
  },
}

local extended_definitions = fignvim.plug.load_module_file("omnisharp_extended")
-- local neosharper = fignvim.plug.load_module_file("neosharper")

if extended_definitions then
  M.opts.handlers = {
    ["textDocument/definition"] = extended_definitions.handler,
  }
end

if neosharper then
  M.opts.on_attach = function(client, bufnr)
    -- neosharper.on_attach(client, bufnr)
  end
end

return M
