local comment = fignvim.plug.load_module_file("Comment")
if not comment then
  return
end

local mappings = require("user-configs.mappings").plugin_mappings["Comment"]

comment.setup({
  opleader = {
    line = mappings.opleader_line.lhs,
    block = mappings.opleader_block.lhs
  },
  toggler = {
    line = mappings.comment_line_toggle.lhs,
    block = mappings.comment_block_toggle.lhs
  },
  extra = {
    above = mappings.comment_above.lhs,
    below = mappings.comment_below.lhs,
    eol = mappings.comment_eol.lhs
  },
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

fignvim.config.create_mapping_group(mappings, "Commenting")
