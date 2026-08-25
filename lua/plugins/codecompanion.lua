-- =============================================================================
-- Auth setup (do once per machine / shell profile)
-- Switch adapters in a chat buffer with `ga`.
--
-- Copilot (HTTP chat / inline) — work default fallback
--   1. Ensure GitHub Copilot subscription is active.
--   2. In Neovim: :Copilot setup  (browser OAuth via copilot.vim)
--   3. Confirm ghost-text works; no env vars required for CodeCompanion.
--
-- Cursor CLI (ACP: cursor_cli) — work agent
--   1. Install Cursor CLI so `agent` is on PATH
--      https://cursor.com/docs/cli/overview
--   2. Prefer interactive login:
--        agent login
--        agent status          # verify authenticated
--   3. Or for non-interactive / CI: create a key at
--      https://cursor.com/dashboard/api  then in your shell:
--        export CURSOR_API_KEY="..."
--   4. Open chat and pick `cursor_cli` with `ga` (or rely on auto-default).
--
-- Claude Code (ACP: claude_code) — home default when available
--   1. Install Claude Code CLI (`claude` on PATH).
--   2. Install Zed's ACP bridge (required by CodeCompanion):
--        npm i -g @zed-industries/claude-agent-acp
--      Confirm: command -v claude-agent-acp
--   3. Auth — pick ONE:
--      A) Claude Pro/Max subscription:
--           claude setup-token
--         Copy the yellow OAuth token, then in your shell:
--           export CLAUDE_CODE_OAUTH_TOKEN="..."
--      B) Anthropic API key (console.anthropic.com):
--           export ANTHROPIC_API_KEY="..."
--   4. Restart Neovim (or re-source env) so the exports are visible.
--   5. Chat defaults to claude_code when claude-agent-acp is executable.
--
-- ponytail: Copilot CLI ACP (copilot_acp) is still buggy — not enabled here.
-- =============================================================================

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

--- Prefer Claude Code at home, then Cursor CLI at work, else Copilot HTTP chat.
---@return string
local function default_chat_adapter()
  if vim.fn.executable("claude-agent-acp") == 1 then
    return "claude_code"
  end
  if vim.fn.executable("agent") == 1 then
    return "cursor_cli"
  end
  return "copilot"
end

local chat_adapter = default_chat_adapter()

require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = chat_adapter,
    },
    inline = {
      -- Inline edits stay on HTTP Copilot; ACP agents are chat-oriented.
      adapter = "copilot",
    },
  },
  adapters = {
    http = {
      opts = {
        show_presets = false,
      },
      copilot = "copilot",
    },
    acp = {
      opts = {
        show_presets = false,
      },
      cursor_cli = function()
        return require("codecompanion.adapters").extend("cursor_cli", {
          defaults = {
            mcpServers = "inherit_from_config",
          },
          env = {
            CURSOR_API_KEY = "CURSOR_API_KEY",
          },
        })
      end,
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code", {
          defaults = {
            mcpServers = "inherit_from_config",
          },
          env = {
            CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
            ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY",
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
vim.keymap.set({ "n", "v" }, "<leader>cA", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Action Palette" })
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
