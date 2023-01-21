fignvim.mappings = {}

function fignvim.mappings.create_core_mappings()
  local core_map_groups = require("core.mappings")

  for groupname, maps in pairs(core_map_groups) do
    fignvim.mappings.register_keymap_group(groupname, maps, true)
  end
end

---Registers a keymap grouping in FigNvim (this means grouping all keymaps in a Legendary folder,
--- and optionally binding them using Legendary)
---@param groupname
---@param mappings
---@param[opt=false] perform_bind boolean
---@param[opt=nil] whichkey_prefix string Whether or not to also create a prefix grouping in which-key
function fignvim.mappings.register_keymap_group(groupname, mappings, perform_bind, whichkey_prefix)
  local legendary_maps = {
    itemgroup = groupname,
    keymaps = fignvim.mappings.make_legendary_keymaps(mappings, perform_bind),
  }

  require("legendary").keymaps(legendary_maps)

  if whichkey_prefix then fignvim.mappings.register_whichkey_prefix(whichkey_prefix, groupname) end
end

function fignvim.mappings.make_legendary_keymaps(mappings, perform_bind)
  local legendary_keys = {}
  for _, map in ipairs(mappings) do
    if perform_bind then
      table.insert(legendary_keys, {
        map[2],
        map[3],
        mode = map[1],
        opts = map[4],
      })
    else
      table.insert(legendary_keys, {
        map[2],
        mode = map[1],
        opts = map[4],
      })
    end
  end

  return legendary_keys
end

function fignvim.mappings.register_whichkey_prefix(prefix, groupname)
  require("which-key").register({
    [prefix] = {
      name = "+" .. groupname,
    },
  })
end

--- Creates a set of keymaps for lazy.nvim plugin configuration
---@param mappings table List of mapping configurations
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

--- Registers a keymap in FigNvim (this means registering it with Legendary, with or without making a binding)
---@param map
---@param[opt=false] perform_bind
function fignvim.mappings.register_keymap(map, perform_bind)
  if perform_bind then
    require("legendary").keymap({
      map[2],
      map[3],
      mode = map[1],
      opts = map[4],
    })
  else
    require("legendary").keymap({
      map[2],
      mode = map[1],
      opts = map[4],
    })
  end
end

return fignvim.mappings
