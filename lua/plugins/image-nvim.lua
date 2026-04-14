vim.pack.add({
  {
    src = "https://github.com/3rd/image.nvim",
    -- build = false is needed when using magick_cli (no Lua rock required)
  },
})

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("image").setup({
      backend = "ueberzug",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
        neorg = {
          enabled = false,
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      scale_factor = 1.0,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = {
        "cmp_menu",
        "cmp_docs",
        "snacks_notif",
        "scrollview",
        "scrollview_sign",
      },
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    })
  end,
})
