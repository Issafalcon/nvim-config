local telescope = fignvim.plug.load_module_file("telescope")
if not telescope then
  return
end
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob=!accounts/",
    },
    prompt_prefix = string.format("%s ", fignvim.ui.get_icon("Search")),
    selection_caret = string.format("%s ", fignvim.ui.get_icon("Selected")),
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_ignore_patterns = { "node_modules" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = { ["q"] = actions.close },
    },
    pickers = {
      grep_string = {
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      live_grep = {
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
    },
    extensions = {
      aerial = {},
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  },
})

fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "notify"), "notify")
fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "aerial"), "aerial")
fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzy_native"), "fzy_native")
fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzf"), "fzf")
fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "nvim-mapper"), "mapper")
