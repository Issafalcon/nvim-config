vim.pack.add({
  {
    src = "https://github.com/mistweaverco/kulala.nvim",
  },
})

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

require("kulala").setup({
  global_keymaps = true,
  global_keymaps_prefix = "<leader>k",
  kulala_keymaps_prefix = "",
  default_env = "default",
  -- Select once (<leader>ke) and keep it for every .http buffer, not just this one.
  environment_scope = "g",
  -- Upstream regression: the kulala-core refactor dropped these two from the plugin's
  -- own defaults, but utils/string.lua still concatenates them unconditionally, so
  -- url_encode errors on every request. Remove once defaults.lua defines them again.
  urlencode_skip = "",
  urlencode_force = "",

  -- <c-h>/<c-l> are window navigation; kulala only binds these inside its own output
  -- buffer, so move tab switching to <Tab>/<S-Tab> and let the pane keys through.
  kulala_keymaps = {
    ["Next tab"] = {
      "<Tab>",
      function()
        require("kulala.ui").show_next_tab()
      end,
      mode = { "n" },
    },
    ["Previous tab"] = {
      "<S-Tab>",
      function()
        require("kulala.ui").show_previous_tab()
      end,
      mode = { "n" },
    },
  },
})
