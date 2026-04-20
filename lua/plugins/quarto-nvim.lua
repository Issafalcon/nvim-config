vim.pack.add({
  {
    src = "https://github.com/jmbuhr/otter.nvim",
  },
  {
    src = "https://github.com/quarto-dev/quarto-nvim",
  },
})

require("quarto").setup({
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    chunks = "curly",
    languages = { "r", "python", "julia", "bash", "html" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = "slime", -- slime is the default; molten takes over via send_cell when initialized
    ft_runners = {},
    never_run = { "yaml" },
  },
})

--- Insert a fenced code chunk, splitting the current chunk if already inside one.
---@param lang string
---@param curly boolean whether to use curly braces (executable chunk)
local function insert_code_chunk(lang, curly)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
  local current_lang = require("otter.keeper").get_current_language_context()
  local inside_chunk = current_lang == lang
  local keys
  if inside_chunk then
    if curly then
      keys = "o```\r\r```{" .. lang .. "}\ro" -- close + reopen
    else
      keys = "o```\r\r```" .. lang .. "\ro"
    end
  else
    if curly then
      keys = "o```{" .. lang .. "}\r```\rO"
    else
      keys = "o```" .. lang .. "\r```\rO"
    end
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function insert_python_chunk()
  insert_code_chunk("python", true)
end
local function insert_r_chunk()
  insert_code_chunk("r", true)
end
local function insert_bash_chunk()
  insert_code_chunk("bash", true)
end
local function insert_lua_chunk()
  insert_code_chunk("lua", true)
end

local runner = require("quarto.runner")

-- Run cells explicitly via quarto runner (always uses configured method)
vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

vim.keymap.set(
  "n",
  "<localleader>rq",
  fignvim.quarto.render_quarto,
  { desc = "Pick format and render quarto buffer", silent = true }
)

-- Quarto preview
vim.keymap.set("n", "<localleader>qp", require("quarto").quartoPreview, { desc = "quarto [p]review", silent = true })
vim.keymap.set(
  "n",
  "<localleader>qq",
  require("quarto").quartoClosePreview,
  { desc = "quarto [q]uit preview", silent = true }
)

-- Code chunk insertion (normal + insert mode)
vim.keymap.set({ "n" }, "<localleader>op", insert_python_chunk, { desc = "insert [p]ython chunk" })
vim.keymap.set({ "n" }, "<localleader>or", insert_r_chunk, { desc = "insert [r] chunk" })
vim.keymap.set({ "n" }, "<localleader>ob", insert_bash_chunk, { desc = "insert [b]ash chunk" })
vim.keymap.set({ "n" }, "<localleader>ol", insert_lua_chunk, { desc = "insert [l]ua chunk" })
