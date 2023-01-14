local markdown_preview_spec = {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = "markdown",
}

return {
  markdown_preview_spec,
}
