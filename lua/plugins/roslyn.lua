vim.pack.add({
  { src = "https://github.com/seblyng/roslyn.nvim" },
})

require("roslyn").setup({
  -- WSL: Roslyn's server-side FileSystemWatcher causes a stack overflow due to
  -- recursive directory watching. "off" tells the server that the client handles
  -- file watching (via Neovim's LSP client), bypassing the broken watcher.
  filewatching = "off",
})

-- Roslyn's solution loading is async and completes well after the buffer opens.
-- When projectInitializationComplete fires, reload each attached buffer to
-- trigger a full refresh of treesitter, semantic tokens, and diagnostics —
-- equivalent to the manual :e the user would otherwise need.
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "RoslynInitialized",
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then
--       return
--     end
--
--     vim.schedule(function()
--       for buf in pairs(client.attached_buffers) do
--         if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and not vim.bo[buf].modified then
--           vim.api.nvim_buf_call(buf, function()
--             vim.cmd.edit()
--           end)
--         end
--       end
--     end)
--   end,
--   desc = "Reload .cs buffers after Roslyn project initialization completes",
-- })
