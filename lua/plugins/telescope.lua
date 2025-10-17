vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzy-native.nvim" },
  { src = "https://github.com/junegunn/fzf" }
})

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle fzf updates',
  group = vim.api.nvim_create_augroup('fzf-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' and event.data.spec.name == 'fzf' then
      vim.notify('fzf updated, running Install...', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.fn["fzf#install"])
      if ok then
        vim.notify('fzf#install completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('fzf#install function not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

      local telescope = require("telescope")

      local actions = require("telescope.actions")
      local icons = require("icons")

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
          prompt_prefix = string.format("%s ", icons.misc.search),
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

local map = vim.keymap.set

  map( "n", "<C-p>", ":lua require('telescope.builtin').git_files()<CR>", { desc = "Search files in git repo" })
  map(
    "n",
    "<leader>tf",
    ":lua require('telescope.builtin').find_files({hidden = true})<CR>",
    { desc = "Search files in current directory" }
  )
  map( "n", "<leader>tb", ":lua require('telescope.builtin').buffers()<CR>", { desc = "Search buffers" })
  map( "n", "<leader>th", ":lua require('telescope.builtin').help_tags()<CR>", { desc = "Search help tags" })
  -- map( "n", "<leader>tc", fignvim.search.dev_config_files, { desc = "Search config files" })
  map( "n", "<leader>tgc", ":lua require('telescope.builtin').git_commits()<CR>", { desc = "Search git commits" })
  map(
    "n",
    "<leader>tbc",
    ":lua require('telescope.builtin').git_bcommits()<CR>",
    { desc = "Search git commits on current branch" }
  )
  map( "n", "<leader>tgb", ":lua require('telescope.builtin').git_branches()<CR>", { desc = "Search git branches" })
  map( "n", "<leader>tgs", ":lua require('telescope.builtin').git_status()<CR>", { desc = "Search git status" })
  map( "n", "<leader>tt", ":lua require('telescope.builtin').colorscheme()<CR>", { desc = "Search colourschemes" })
  map( "n", "<leader>tm", ":lua require('telescope.builtin').marks()<CR>", { desc = "Search marks" })
  map( "n", "<leader>tr", ":lua require('telescope.builtin').registers()<CR>", { desc = "Search registers" })
  map(
    "i",
    "<A-2>",
    ":lua require('telescope.builtin').registers()<CR>",
    { desc = "Search registers while in insert mode" }
  )
  map(
    "n",
    "<leader>tvc",
    ":lua require('telescope.builtin').command_history()<CR>",
    { desc = "Search command history" }
  )
  map("n", "<leader>ts", ":Telescope aerial<CR>", { desc = "Search through Aerial Symbols" })
