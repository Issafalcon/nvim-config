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
  picker = {
    enabled = true,
    ui_select = true,
    -- My ~/github/dotfiles-latest/neovim/lazyvim/lua/config/keymaps.lua
    -- file was always showing at the top, I needed a way to decrease its
    -- score, in frecency you could use :FrecencyDelete to delete a file
    -- from the database, here you can decrease it's score
    transform = function(item)
      if not item.file then
        return item
      end
      -- Demote the "lazyvim" keymaps file:
      if item.file:match("lazyvim/lua/config/keymaps%.lua") then
        item.score_add = (item.score_add or 0) - 30
      end
      -- Demote my old kanata config file
      if item.file:match("kanata/configs/macos%.kbd") then
        item.score_add = (item.score_add or 0) - 30
      end
      -- Boost the "neobean" keymaps file:
      -- if item.file:match("neobean/lua/config/keymaps%.lua") then
      --   item.score_add = (item.score_add or 0) + 100
      -- end
      return item
    end,
    -- In case you want to make sure that the score manipulation above works
    -- or if you want to check the score of each file
    debug = {
      scores = false, -- show scores in the list
    },
    -- I like the "ivy" layout, so I set it as the default globaly, you can
    -- still override it in different keymaps
    layout = {
      preset = "ivy",
      -- When reaching the bottom of the results in the picker, I don't want
      -- it to cycle and go back to the top
      cycle = false,
    },
    layouts = {
      -- I wanted to modify the ivy layout height and preview pane width,
      -- this is the only way I was able to do it
      -- NOTE: I don't think this is the right way as I'm declaring all the
      -- other values below, if you know a better way, let me know
      --
      -- Then call this layout in the keymaps above
      -- got example from here
      -- https://github.com/folke/snacks.nvim/discussions/468
      ivy = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.5,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "bottom" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", width = 0.5, border = "left" },
          },
        },
      },
      -- I wanted to modify the layout width
      --
      vertical = {
        layout = {
          backdrop = false,
          width = 0.8,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
      select = {
        -- Make select transparent
        layout = {
          backdrop = false,
        },
      },
    },
    matcher = {
      frecency = true,
    },
    win = {
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          -- ["<Esc>"] = { "close", mode = { "n", "i" } },
          -- I'm used to scrolling like this in LazyGit
          ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
          ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
    formatters = {
      file = {
        filename_first = true, -- display filename before the file path
        truncate = 80,
      },
    },
  },
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

vim.keymap.set("n", "<leader>G", function()
  Snacks.gitbrowse()
end, { desc = "ToggleTerm with gitbrowse" })

vim.keymap.set("n", "<leader>nd", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss all notifications" })

vim.keymap.set("n", "<leader>nh", function()
  Snacks.notifier.show_history()
end, { desc = "Show notification history" })

vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Close current buffer" })

------------------------------------------
--------- Snacks.picker ------------------
-------------------------------------------

vim.keymap.set("n", "<leader>th", function()
  Snacks.picker.help()
end, { desc = "Search help tags" })

vim.keymap.set("n", "<leader>tb", function()
  Snacks.picker.buffers()
end, { desc = "Search open buffers" })

-- Git
vim.keymap.set("n", "<leader>tgl", function()
  Snacks.picker.git_log()
end, { desc = "Search git logs" })

vim.keymap.set("n", "<leader>tgd", function()
  Snacks.picker.git_diff()
end, { desc = "Search git diff" })

vim.keymap.set("n", "<leader>tr", function()
  Snacks.picker.registers()
end, { desc = "Search registers" })

-- Files
vim.keymap.set("n", "<C-p>", function()
  Snacks.picker.git_files()
end, { desc = "Search files in git repo" })

vim.keymap.set("n", "<leader>tf", function()
  Snacks.picker.files()
end, { desc = "Search files in current directory" })

-- LSP
vim.keymap.set("n", "<leader>tS", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "List workspace symbols in Snacks.picker" })

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
