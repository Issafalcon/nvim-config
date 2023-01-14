local telescope_mappings = {
  { "n", "<C-p>", ":lua require('telescope.builtin').git_files()<CR>", { desc = "Search files in git repo" } },
  {
    "n",
    "<leader>tf",
    ":lua require('telescope.builtin').find_files({hidden = true})<CR>",
    { desc = "Search files in current directory" },
  },
  { "n", "<leader>tb", ":lua require('telescope.builtin').buffers()<CR>", { desc = "Search buffers" } },
  { "n", "<leader>th", ":lua require('telescope.builtin').help_tags()<CR>", { desc = "Search help tags" } },
  { "n", "<leader>tc", fignvim.search.dev_config_files, { desc = "Search config files" } },
  { "n", "<leader>tgc", ":lua require('telescope.builtin').git_commits()<CR>", { desc = "Search git commits" } },
  {
    "n",
    "<leader>tbc",
    ":lua require('telescope.builtin').git_bcommits()<CR>",
    { desc = "Search git commits on current branch" },
  },
  { "n", "<leader>tgb", ":lua require('telescope.builtin').git_branches()<CR>", { desc = "Search git branches" } },
  { "n", "<leader>tgs", ":lua require('telescope.builtin').git_status()<CR>", { desc = "Search git status" } },
  { "n", "<leader>tt", ":lua require('telescope.builtin').colorscheme()<CR>", { desc = "Search colourschemes" } },
  { "n", "<leader>tm", ":lua require('telescope.builtin').marks()<CR>", { desc = "Search marks" } },
  { "n", "<leader>tr", ":lua require('telescope.builtin').registers()<CR>", { desc = "Search registers" } },
  {
    "i",
    "<A-2>",
    ":lua require('telescope.builtin').registers()<CR>",
    { desc = "Search registers while in insert mode" },
  },
  {
    "n",
    "<leader>tvc",
    ":lua require('telescope.builtin').command_history()<CR>",
    { desc = "Search command history" },
  },
  { "n", "<leader>ta", ":Telescope aerial<CR>", { desc = "Search through Aerial Symbols" } },
}

local telescope_spec = {
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    {
      "junegunn/fzf",
    },
  },
  keys = fignvim.config.make_lazy_keymaps(telescope_mappings),
  config = function()
    local telescope = fignvim.plug.load_module_file("telescope")
    local actions = require("telescope.actions")
    if not telescope then return end
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
    fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzy_native"), "fzy_native")
    fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "fzf"), "fzf")

    fignvim.config.register_keymap_group("Telescope", telescope_mappings, "<leader>t")
  end,
}

return telescope_spec
