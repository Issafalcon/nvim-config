vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

local M = {}

M.colours = {
  linkarzu_color18 = "#002931",
  linkarzu_color19 = "#1c1c1c",
  linkarzu_color20 = "#393939",
  linkarzu_color21 = "#736902",
  linkarzu_color22 = "#453f01",
  linkarzu_color23 = "#7b7b7b",
  linkarzu_color26 = "#000000",
  linkarzu_color04 = "#667e83",
  linkarzu_color02 = "#666666",
  linkarzu_color03 = "#c2c2c2",
  linkarzu_color01 = "#c0b004",
  linkarzu_color05 = "#877c03",
  linkarzu_color08 = "#ffffff",
  linkarzu_color06 = "#c3f4fe",
  linkarzu_color10 = "#000000",
  linkarzu_color17 = "#0a0a0a",
  linkarzu_color07 = "#141414",
  linkarzu_color25 = "#1f1f1f",
  linkarzu_color13 = "#333333",
  linkarzu_color15 = "#474747",
  linkarzu_color09 = "#8a96b1",
  linkarzu_color11 = "#f8b4b8",
  linkarzu_color12 = "#fef9c6",
  linkarzu_color14 = "#ffffff",
  linkarzu_color16 = "#0390ac",
  linkarzu_color24 = "#04d1f9",
  none = "NONE",
  fg = "#abb2bf",
  bg = "#1e222a",
  bg_1 = "#303742",
  black = "#181a1f",
  black_1 = "#1f1f25",
  green = "#98c379",
  green_1 = "#89b06d",
  green_2 = "#95be76",
  white = "#dedede",
  white_1 = "#afb2bb",
  white_2 = "#c9c9c9",
  blue = "#61afef",
  blue_1 = "#40d9ff",
  blue_2 = "#1b1f27",
  blue_3 = "#8094B4",
  blue_4 = "#90c7f3",
  orange = "#d19a66",
  orange_1 = "#ff9640",
  orange_2 = "#ff8800",
  yellow = "#e5c07b",
  yellow_1 = "#ebae34",
  yellow_2 = "#d1b071",
  red = "#e06c75",
  red_1 = "#ec5f67",
  red_2 = "#ffbba6",
  red_3 = "#cc626a",
  red_4 = "#d47d85",
  red_5 = "#e9989e",
  grey = "#5c6370",
  grey_1 = "#4b5263",
  grey_2 = "#777d86",
  grey_3 = "#282c34",
  grey_4 = "#2c323c",
  grey_5 = "#3e4452",
  grey_6 = "#3b4048",
  grey_7 = "#5c5c5c",
  grey_8 = "#252931",
  grey_9 = "#787e87",
  grey_10 = "#D3D3D3",
  gold = "#ffcc00",
  cyan = "#56b6c2",
  cyan_1 = "#88cbd4",
  purple = "#c678dd",
  purple_1 = "#a9a1e1",
  purple_2 = "#c2bdea",

  -- icon colors
  c = "#519aba",
  css = "#61afef",
  deb = "#a1b7ee",
  docker = "#384d54",
  html = "#de8c92",
  jpeg = "#c882e7",
  jpg = "#c882e7",
  js = "#ebcb8b",
  jsx = "#519ab8",
  kt = "#7bc99c",
  lock = "#c4c720",
  lua = "#51a0cf",
  mp3 = "#d39ede",
  mp4 = "#9ea3de",
  out = "#abb2bf",
  png = "#c882e7",
  py = "#a3b8ef",
  rb = "#ff75a0",
  robots = "#abb2bf",
  rpm = "#fca2aa",
  rs = "#dea584",
  toml = "#39bf39",
  ts = "#519aba",
  ttf = "#abb2bf",
  vue = "#7bc99c",
  woff = "#abb2bf",
  woff2 = "#abb2bf",
  zip = "#f9d71c",
  md = "#519aba",
}

local normal = fignvim.ui.get_hlgroup("Normal")
local fg, bg = normal.fg, M.colours.black
local green = fignvim.ui.get_hlgroup("String").fg
local red = fignvim.ui.get_hlgroup("Error").fg

vim.api.nvim_set_hl(0, "Whitespace", { fg = "#4b5263" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#CBA6F7" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = M.colours.grey_7, fg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = fg, bg = M.colours.bg_1 })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = M.colours.orange_2 })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = bg, bg = bg })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = bg })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = bg, bg = green })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = M.colours.bg_1, bg = M.colours.bg_1 })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = fg, bg = M.colours.bg_1 })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = red, bg = M.colours.bg_1 })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = M.colours.black, bg = M.colours.vue })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = bg, bg = bg })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = bg })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = bg, bg = bg })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", fg = "#808080", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpItemAbbrMatch" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
vim.api.nvim_set_hl(0, "BqfPreviewBorder", { fg = M.colours.vue })
vim.api.nvim_set_hl(0, "BqfPreviewRange", { link = "Search" })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = M.colours.grey_7, bg = "NONE" })

return M
