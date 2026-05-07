vim.pack.add({
  { src = "https://www.github.com/olimorris/codecompanion.nvim" },
})

--- Load MCP servers from ~/.copilot/mcp-config.json
---@return table<string, table>
local function load_mcp_servers()
  local config_path = vim.fn.expand("~/.copilot/mcp-config.json")
  local ok, content = pcall(vim.fn.readfile, config_path)
  if not ok or vim.tbl_isempty(content) then
    return {}
  end

  local parsed_ok, config = pcall(vim.json.decode, table.concat(content, "\n"))
  if not parsed_ok or not config or not config.mcpServers then
    return {}
  end

  local servers = {}
  for name, server in pairs(config.mcpServers) do
    local cmd = { server.command }
    if server.args then
      for _, arg in ipairs(server.args) do
        table.insert(cmd, arg)
      end
    end
    servers[name] = {
      cmd = cmd,
      env = server.env,
    }
  end

  return servers
end

require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
  },
  adapters = {
    acp = {
      copilot_cli = function()
        return require("codecompanion.adapters").extend("copilot_cli", {
          defaults = {
            mcpServers = "inherit_from_config",
          },
        })
      end,
    },
  },
  mcp = {
    servers = load_mcp_servers(),
  },
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "<C-\\>", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "New CodeCompanion Chat" })
vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to CodeCompanion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>cp", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Action Palette" })
vim.keymap.set("n", "<leader>cd", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diagnostics == 0 then
    vim.notify("No diagnostics on current line", vim.log.levels.INFO)
    return
  end
  local messages = {}
  for _, d in ipairs(diagnostics) do
    table.insert(messages, d.message)
  end
  vim.cmd("CodeCompanionChat")
  vim.schedule(function()
    local chat_buf = vim.bo.filetype == "codecompanion" and vim.api.nvim_get_current_buf() or nil
    if chat_buf then
      vim.api.nvim_buf_set_lines(chat_buf, -1, -1, false, {
        "",
        "Help me fix these diagnostics:",
        "",
        table.concat(messages, "\n"),
      })
    end
  end)
end, { desc = "Send diagnostics to CodeCompanion" })
