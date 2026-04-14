vim.pack.add({
  {
    src = "https://github.com/jpalardy/vim-slime",
  },
})

vim.b["quarto_is_python_chunk"] = false
Quarto_is_in_python_chunk = function()
  require("otter.tools.functions").is_otter_language_context("python")
end

vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]])

vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = true
vim.g.slime_python_ipython = 1
vim.g.slime_input_pid = false
vim.g.slime_suggest_default = true
vim.g.slime_menu_config = false
-- false: include unlisted buffers (e.g. toggleterm) in the terminal picker
vim.g.slime_neovim_ignore_unlisted = false

--- Smart cell runner: uses molten (via QuartoSend) when a kernel is active,
--- otherwise falls back to vim-slime. This mirrors the jmbuhr kickstarter pattern.
local function send_cell()
  local has_molten, molten_status = pcall(require, "molten.status")
  if has_molten then
    local ok, kernels = pcall(molten_status.kernels)
    if ok and kernels ~= nil and kernels ~= "" then
      vim.cmd("QuartoSend")
      return
    end
  end
  vim.fn["slime#send_cell"]()
end

local slime_send_region_cmd = ":<C-u>call slime#send_op(visualmode(), 1)<CR>"
slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)

--- Smart region runner: uses molten run_range when a kernel is active,
--- otherwise falls back to vim-slime visual send.
local function send_region()
  local has_molten, molten_status = pcall(require, "molten.status")
  if has_molten then
    local ok, kernels = pcall(molten_status.kernels)
    if ok and kernels ~= nil and kernels ~= "" then
      require("quarto.runner").run_range()
      return
    end
  end
  vim.cmd("normal" .. slime_send_region_cmd)
end

--- Open a new listed terminal split that vim-slime can see.
--- ToggleTerm buffers are unlisted; these vsplit terminals are listed.
local function new_terminal(lang)
  vim.cmd("vsplit term://" .. lang)
end

local function new_terminal_python()
  new_terminal("python3")
end

local function new_terminal_ipython()
  new_terminal("ipython --no-confirm-exit --no-autoindent")
end

local function new_terminal_r()
  new_terminal("R --no-save")
end

local function new_terminal_shell()
  new_terminal(vim.o.shell)
end

local function mark_terminal()
  local job_id = vim.b.terminal_job_id
  vim.print("job_id: " .. job_id)
end

local function set_terminal()
  vim.fn.call("slime#config", {})
end

-- Run cell / region (smart: molten if active, else slime)
-- <c-cr> / <s-cr> mirrors the RStudio-style "run cell" feel
vim.keymap.set({ "n", "i" }, "<c-cr>", send_cell, { desc = "run code cell" })
vim.keymap.set({ "n", "i" }, "<s-cr>", send_cell, { desc = "run code cell" })
vim.keymap.set("n", "<leader><cr>", send_cell, { desc = "run code cell" })
vim.keymap.set("v", "<cr>", send_region, { desc = "run code region" })

-- Terminal management
vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
vim.keymap.set("n", "<leader>cp", new_terminal_python, { desc = "new [p]ython terminal" })
vim.keymap.set("n", "<leader>ci", new_terminal_ipython, { desc = "new [i]python terminal" })
vim.keymap.set("n", "<leader>cr", new_terminal_r, { desc = "new [R] terminal" })
vim.keymap.set("n", "<leader>cn", new_terminal_shell, { desc = "[n]ew shell terminal" })
