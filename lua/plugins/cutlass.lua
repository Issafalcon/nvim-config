local cutlass_mappings = {
  { { "n", "x" }, "m", "d", { desc = "Cutlass: Cut char to clipboard" } },
  { "n", "mm", "dd", { desc = "Cutlass: Cut line to clipboard" } },
  { "n", "M", "D", { desc = "Cutlass: Cut from cursor to end of line, to clipboard" } },
  { "n", "\\m", "m", { desc = "Cutlass: Remap create mark key so it isn't shadowed" } },
}

return {
  {
    "svermeulen/vim-cutlass",
    event = "BufReadPost",
    keys = fignvim.mappings.make_lazy_keymaps(cutlass_mappings, true),
  },
}
