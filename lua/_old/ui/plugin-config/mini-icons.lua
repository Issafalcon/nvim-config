---@type FigNvimPluginConfig
local M = {}

M.lazy_init = function()
  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end
end

M.lazy_opts = {
  file = {
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
  },
  filetype = {
    dotenv = { glyph = "", hl = "MiniIconsYellow" },
  },
}

M.setup = function()
  M.lazy_init()
  require("mini.icons").setup(M.lazy_opts)
end

return M
