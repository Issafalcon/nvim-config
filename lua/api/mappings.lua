fignvim.mappings = {}

--- Registers all core mappings in FigNvim
function fignvim.mappings.create_core_mappings()
  local core_map_groups = require("core.mappings")

  for _, maps in pairs(core_map_groups) do
    fignvim.mappings.create_keymaps(maps)
  end
end

--- Creates a set of keymaps when given a table of vim.api.nvim_set_keymap() compatible mappings
---@param mappings
function fignvim.mappings.create_keymaps(mappings)
  for _, map in ipairs(mappings) do
    vim.keymap.set(unpack(map))
  end
end

--- Registers a prefix in which-key without binding any keymaps
---@param prefix string The keymap prefix to register
---@param groupname string The name of the group
function fignvim.mappings.register_whichkey_prefix(prefix, groupname)
  require("which-key").register({
    [prefix] = {
      name = "+" .. groupname,
    },
  })
end

--- Creates a set of keymaps for lazy.nvim plugin configuration
---@param mappings table List of mapping configurations compatible with vim.api.nvim_set_keymap()
---@param[opt=false] perform_bind boolean True if the bindings should not be made by lazy.nvim
---@return table Lazy Compatible keymaps
function fignvim.mappings.make_lazy_keymaps(mappings, perform_bind)
  local lazy_keys = {}
  for _, map in ipairs(mappings) do
    table.insert(
      lazy_keys,
      vim.tbl_deep_extend("force", {
        map[2],
        perform_bind and map[3] or nil,
        mode = map[1],
      }, map[4] or {})
    )
  end

  return lazy_keys
end

return fignvim.mappings
