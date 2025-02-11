do
  -- Specifies where to install/use rocks.nvim
  local install_location =
    vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rocks")

  -- Set up configuration options related to rocks.nvim (recommended to leave as default)
  local rocks_config = {
    rocks_path = vim.fs.normalize(install_location),
    treesitter = {
      auto_highlight = "all",
      auto_install = "prompt",
      parser_map = {},
      ---@type string[] | fun(lang: string, bufnr: integer):boolean
      disable = {
        "latex",
      }, -- filetypes or a function
      config_path = "lua/plugin-rocks/syntax/rocks-treesitter.toml",
    },
  }

  vim.g.rocks_nvim = rocks_config

  -- Configure the package path (so that plugin code can be found)
  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

  -- Configure the C path (so that e.g. tree-sitter parsers can be found)
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

  -- Add rocks.nvim to the runtimepath
  vim.opt.runtimepath:append(
    vim.fs.joinpath(
      rocks_config.rocks_path,
      "lib",
      "luarocks",
      "rocks-5.1",
      "rocks.nvim",
      "*"
    )
  )
end
