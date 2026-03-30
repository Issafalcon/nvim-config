local function set_python_path(command)
  local path = command.args
  -- Search all pyright clients so this works from quarto buffers (where pyright
  -- attaches to otter's hidden Python buffers rather than the current buffer).
  local clients = vim.lsp.get_clients({ name = "pyright" })
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python =
        vim.tbl_deep_extend("force", client.settings.python --[[@as table]], { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    client:notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

-- Creates the pyright user commands on `buf`. `client_buf` is the buffer that
-- pyright is actually attached to (may differ for otter virtual buffers).
local function create_pyright_commands(buf, client_buf)
  if vim.b[buf]._pyright_cmds_registered then
    return
  end
  vim.b[buf]._pyright_cmds_registered = true

  vim.api.nvim_buf_create_user_command(buf, "LspPyrightOrganizeImports", function()
    local params = {
      command = "pyright.organizeimports",
      arguments = { vim.uri_from_bufnr(client_buf) },
    }
    -- Using client.request() directly because "pyright.organizeimports" is private
    -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
    -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
    local clients = vim.lsp.get_clients({ bufnr = client_buf, name = "pyright" })
    for _, client in ipairs(clients) do
      ---@diagnostic disable-next-line: param-type-mismatch
      client.request("workspace/executeCommand", params, nil, client_buf)
    end
  end, {
    desc = "Organize Imports",
  })

  vim.api.nvim_buf_create_user_command(buf, "LspPyrightSetPythonPath", set_python_path, {
    desc = "Reconfigure pyright with the provided python path",
    nargs = 1,
    complete = "file",
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("pyright-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "pyright" then
      return
    end

    -- Register on the buffer pyright attached to (plain .py file or otter virtual buf)
    create_pyright_commands(args.buf, args.buf)

    -- Also register on any open quarto buffers so the commands are available
    -- when pyright is attached via otter to a hidden virtual Python buffer.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "quarto" then
        create_pyright_commands(buf, args.buf)
      end
    end
  end,
})

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    python = {
      pythonPath = vim.fn.expand("~/python3/envs/neovim/bin/python3"),
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
