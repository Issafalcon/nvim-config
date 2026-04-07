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
vim.g.slime_neovim_ignore_unlisted = true

local function mark_terminal()
  local job_id = vim.b.terminal_job_id
  vim.print("job_id: " .. job_id)
end

local function set_terminal()
  vim.fn.call("slime#config", {})
end
vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
