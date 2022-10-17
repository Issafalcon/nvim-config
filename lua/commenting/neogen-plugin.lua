local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
  return
end

local maps = require("custom_config").mappings
local mapper = require("utils.mapper")
local opts = { silent = true, noremap = true }

neogen.setup({
  snippet_support = "luasnip",
})

mapper.map(
  "n",
  maps.commenting.generate_annotation .. "F",
  "<cmd>lua require('neogen').generate({type = 'file'})<CR>",
  opts,
  "Commenting",
  "commenting_annotate_file",
  "Generates filetype specific annotations for the nearest file"
)
mapper.map(
  "n",
  maps.commenting.generate_annotation .. "f",
  "<cmd>lua require('neogen').generate({type = 'func'})<CR>",
  opts,
  "Commenting",
  "commenting_annotate_func",
  "Generates filetype specific annotations for the nearest function"
)
mapper.map(
  "n",
  maps.commenting.generate_annotation .. "c",
  "<cmd>lua require('neogen').generate({type = 'class'})<CR>",
  opts,
  "Commenting",
  "commenting_annotate_class",
  "Generates filetype specific annotations for the nearest class"
)
mapper.map(
  "n",
  maps.commenting.generate_annotation .. "t",
  "<cmd>lua require('neogen').generate({type = 'type'})<CR>",
  opts,
  "Commenting",
  "commenting_annotate_type",
  "Generates filetype specific annotations for the nearest type"
)
