local web_devicons_spec = {
  "nvim-tree/nvim-web-devicons",
  event = "BufReadPre",
  enabled = vim.g.icons_enabled,
  configs = function()
    local icons = require("nvim-web-devicons")
    icons.set_icon({
      deb = { icon = "", name = "Deb" },
      lock = { icon = "", name = "Lock" },
      mp3 = { icon = "", name = "Mp3" },
      mp4 = { icon = "", name = "Mp4" },
      out = { icon = "", name = "Out" },
      ["robots.txt"] = { icon = "ﮧ", name = "Robots" },
      ttf = { icon = "", name = "TrueTypeFont" },
      rpm = { icon = "", name = "Rpm" },
      woff = { icon = "", name = "WebOpenFontFormat" },
      woff2 = { icon = "", name = "WebOpenFontFormat2" },
      xz = { icon = "", name = "Xz" },
      zip = { icon = "", name = "Zip" },
      tex = { icon = "", name = "Tex" },
    })
  end,
}

local lsp_kind_spec = {
  "onsails/lspkind.nvim",
  event = "BufReadPre",
  config = function()
    local lspkind = require("lspkind")
    fignvim.lspkind = {
      mode = "symbol",
      symbol_map = fignvim.ui.lspkind_icons,
    }

    lspkind.init(fignvim.lspkind)
  end,
}

return {
  web_devicons_spec,
  lsp_kind_spec,
}
