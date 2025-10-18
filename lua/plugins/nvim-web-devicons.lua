vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("nvim-web-devicons").setup({
  default = true,
  override = {
    deb = { icon = "", name = "Deb" },
    lock = { icon = "", name = "Lock" },
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
  },
  strict = true,
})
