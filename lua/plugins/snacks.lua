vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

local notify = vim.notify

require("snacks").setup({
  image = { enabled = true },
  scroll = { enabled = true },
  lazygit = { enabled = true },
  gitbrowse = { enabled = true },
  styles = {
    styles = {
      lazygit = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
  },
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = true },
  picker = { enabled = false },
  notifier = { enabled = true },
  quickfile = { enabled = false },
  scope = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  terminal = { enabled = false },
})

local noice_installed, _ = pcall(vim.pack.get, { "noice.nvim" })

if noice_installed then
  -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
  -- this is needed to have early notifications show up in noice history
  vim.notify = notify
end

vim.keymap.set("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "Open lazygit in Snacks" })

vim.keymap.set("n", "<leader>gb", function()
  Snacks.gitbrowse()
end, { desc = "ToggleTerm with gitbrowse" })

vim.keymap.set("n", "<leader>nd", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss all notifications" })

-- Fancy lsp progress notifications for notifier (https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
