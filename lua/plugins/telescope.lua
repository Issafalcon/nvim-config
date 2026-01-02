vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzy-native.nvim" },
  { src = "https://github.com/junegunn/fzf" },
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle fzf updates",
  group = vim.api.nvim_create_augroup("fzf-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "fzf" then
      vim.notify("fzf updated, running Install...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.fn["fzf#install"])
      if ok then
        vim.notify("fzf#install completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("fzf#install function not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})

local telescope = require("telescope")

local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = { ["q"] = actions.close },
    },
  },
})

fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzy_native"), "fzy_native")
fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzf"), "fzf")
