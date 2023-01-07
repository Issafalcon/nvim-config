local is_available = fignvim.plug.is_available
local mappings = {
  n = {
    ["<leader>"] = {},
  },
}

local extra_sections = {
  b = "Buffers",
  d = "Debugger",
  h = "Git",
  s = "Search",
  t = "Terminal",
  u = "Testing",
}

local function init_table(mode, prefix, idx)
  if not mappings[mode][prefix][idx] then
    mappings[mode][prefix][idx] = { name = extra_sections[idx] }
  end
end

if is_available("gitsigns.nvim") then
  init_table("n", "<leader>", "h")
end

if is_available("toggleterm.nvim") then
  init_table("n", "<leader>", "g")
  init_table("n", "<leader>", "t")
end

if is_available("telescope.nvim") or is_available("nvim-spectre") then
  init_table("n", "<leader>", "s")
end

if is_available("nvim-dap") then
  init_table("n", "<leader>", "d")
end

if is_available("neotest") then
  init_table("n", "<leader>", "u")
end

if is_available("Comment.nvim") then
  for _, mode in ipairs({ "n", "v" }) do
    if not mappings[mode] then
      mappings[mode] = {}
    end
    if not mappings[mode].g then
      mappings[mode].g = {}
    end
    mappings[mode].g.c = "Comment toggle linewise"
    mappings[mode].g.b = "Comment toggle blockwise"
  end
end

fignvim.config.which_key_register(mappings)
