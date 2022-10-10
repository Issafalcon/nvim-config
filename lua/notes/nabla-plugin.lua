local opts = { noremap = true, silent = true }
local maps = require("custom_config").mappings
local mapper = require("utils.mapper")

mapper.map("n", maps.notes.display_equation, ":lua require('nabla').popup()<CR>", opts, "Notes", "notes_equation", "Display equation in ASCII under the cursor")
