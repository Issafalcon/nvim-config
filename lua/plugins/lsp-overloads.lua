vim.pack.add({
  { src = "https://github.com/Issafalcon/lsp-overloads.nvim", version = "refactor/best-practices" },
})

local lsp_overloads_ok, lsp_overloads = pcall(require, "lsp-overloads")
if lsp_overloads_ok then
  lsp_overloads.setup(client, {
    ui = {
      close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
      floating_window_above_cur_line = true,
      silent = true,
      border = "rounded",
    },
  })
end

vim.keymap.set(
  { "n", "i" },
  "<A-s>",
  "<cmd>LspOverloads signature<CR>",
  { silent = true, desc = "Show signature help with overloads" }
)
