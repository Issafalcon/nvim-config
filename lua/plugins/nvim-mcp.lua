vim.pack.add({
  {
    src = "https://github.com/linw1995/nvim-mcp",
  },
})

local opts = {}
if vim.fn.has("win32") == 1 then
  -- Upstream builds TEMP/nvim-mcp.<gitroot>.<pid>.sock and only escapes '/'.
  -- Windows paths keep ':' and '\', so serverstart fails with ENOENT.
  -- A name with no separators becomes \\.\pipe\<name>.<pid>.<n>.
  opts.pipe = string.format("nvim-mcp.%d", vim.fn.getpid())
end

require("nvim-mcp").setup(opts)
