local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

local maps = require("custom_config").mappings
local mapper = require("utils.mapper")

comment.setup({
  opleader = {
    line = maps.commenting.line_comment,
    block = maps.commenting.block_comment,
  },
  toggler = {
    line = maps.commenting.line_comment .. "c",
    block = maps.commenting.block_comment .. "c",
  },
  extra = {
    above = maps.commenting.line_comment .. "O",
    below = maps.commenting.line_comment .. "o",
    eol = maps.commenting.line_comment .. "A",
  },
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

mapper.map_virtual(
  "o",
  maps.commenting.line_comment,
  "",
  {},
  "Commenting",
  "comment_line_op",
  "Operator pending prefix for line commenting in Normal and Visual modes"
)
mapper.map_virtual(
  "o",
  maps.commenting.block_comment,
  "",
  {},
  "Commenting",
  "comment_block_op",
  "Operator pending prefix for block commenting in Normal and Visual modes"
)
mapper.map_virtual(
  "n",
  maps.commenting.line_comment .. "c",
  "",
  {},
  "Commenting",
  "comment_toggle_line",
  "Toggle line comment"
)
mapper.map_virtual(
  "n",
  maps.commenting.block_comment .. "c",
  "",
  {},
  "Commenting",
  "comment_toggle_block",
  "Toggle block comment"
)
mapper.map_virtual(
  "n",
  maps.commenting.line_comment .. "O",
  "",
  {},
  "Commenting",
  "comment_above",
  "Add a comment on the line above"
)
mapper.map_virtual(
  "n",
  maps.commenting.line_comment .. "o",
  "",
  {},
  "Commenting",
  "comment_below",
  "Add a comment on the line below"
)
mapper.map_virtual(
  "n",
  maps.commenting.line_comment .. "A",
  "",
  {},
  "Commenting",
  "comment_eol",
  "Add a comment at the end of the line"
)
