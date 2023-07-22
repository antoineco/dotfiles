---@type Base46Table
local M = {}

-- local colours = require "everforest.colours"
-- local highlights = require "everforest.highlights"
--
-- local cfg = require "everforest".config
-- local palette = colours.generate_palette(cfg, vim.o.background)
-- local syn = highlights.generate_syntax(palette, cfg)
--
-- local output = {}
-- for line in vim.inspect(over):gmatch("[^\n]+") do
--   table.insert(output, line)
-- end
-- local buf = vim.api.nvim_create_buf(true, true)
-- vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
-- vim.api.nvim_win_set_buf(0, buf)

M.type = "dark"

-- stylua: ignore
M.base_30 = {
  white         = "#d3c6aa",
  darker_black  = "#232a2e", -- LSP/cmp pop-ups, tree bg
  black         = "#2d353b", -- cmp bg, icons/headers fg
  black2        = "#343f44", -- tabline bg, cursor lines, selections
  one_bg        = "#343f44", -- pop-up menu bg, statusline icon fg
  one_bg2       = "#3d484d", -- tabline inactive bg, indent line context start
  one_bg3       = "#475258", -- tabline toggle/new btn, borders
  grey          = "#4f585e", -- line nr, scrollbar, indent line hover
  grey_fg       = "#4f585e", -- comment
  grey_fg2      = "#ff0000", -- unused
  light_grey    = "#9da9a0", -- diff change, tabline inactive fg
  line          = "#3d484d", -- win sep, indent line
  statusline_bg = "#343f44", -- statusline
  lightbg       = "#3d484d", -- statusline components
  pmenu_bg      = "#83c092", -- pop-up menu selection
  folder_bg     = "#83c092", -- tree items
  red           = "#e67e80", -- diff delete, diag error
  pink          = "#ff75a0", -- indicators
  baby_pink     = "#ce8196", -- dev icons
  green         = "#83c092", -- diff add, diag info, indicators
  vibrant_green = "#a7c080", -- dev icons
  orange        = "#e69875", -- diff mod
  yellow        = "#dbbc7f", -- diag warn
  sun           = "#d1b171", -- dev icons
  blue          = "#7393b3", -- ui elements, dev/cmp icons
  nord_blue     = "#78b4ac", -- indicators
  purple        = "#ecafcc", -- diag hint, dev/cmp icons
  dark_purple   = "#d699b6", -- dev icons
  teal          = "#69a59d", -- dev/cmp icons
  cyan          = "#95d1c9", -- dev/cmp icons
}

M.base_16 = {
  base00 = "#2d353b", -- bg
  base01 = "#343f44", -- fold bg
  base02 = "#3d484d", -- visual
  base03 = "#475258", -- special keys, signs, fold fg
  base04 = "#4f585e", -- def underline
  base05 = "#d3c6aa", -- fg, var, operator, ref, txt
  base06 = "#ff0000", -- unused
  base07 = "#d8d3ba", -- cmp icons
  base08 = "#7fbbb3", -- const, char, identifier, field, namespace, error, spell
  base09 = "#d699b6", -- num, bool, builtin const/var, uri, inc search
  base0A = "#83c092", -- attribute, type, repeat, tag, todo, search, wild bg
  base0B = "#dbbc7f", -- string, symbol
  base0C = "#e69875", -- constructor, special, regex, fold column
  base0D = "#a7c080", -- func
  base0E = "#e67e80", -- keyword
  base0F = "#d699b6", -- delimiter, special char
}

--- Off base46 palette
---@type table<string, string>
local extras = {
  bg_visual = "#543a48",
}

M.polish_hl = {
  Repeat = {
    fg = M.base_30.red,
  },
  String = {
    fg = M.base_30.green,
  },
  Tag = {
    fg = M.base_30.orange,
  },
  Type = {
    fg = M.base_30.yellow,
    italic = true,
  },
  Typedef = {
    fg = M.base_30.yellow,
    italic = true,
  },
  Visual = {
    bg = extras.bg_visual,
  },
  ["@constant"] = {
    fg = M.base_30.white,
  },
  ["@operator"] = {
    fg = M.base_30.orange,
  },
  ["@punctuation.bracket"] = {
    fg = M.base_30.white,
  },
  ["@punctuation.delimiter"] = {
    fg = M.base_30.grey_fg,
    link = "",
  },
  ["@string"] = {
    fg = M.base_30.green,
  },
  ["@tag"] = {
    fg = "",
  },
  ["@tag.delimiter"] = {
    fg = M.base_30.vibrant_green,
  },
  ["@type.builtin"] = {
    fg = M.base_30.yellow,
    italic = true,
  },
  ["@constant.builtin.go"] = {
    fg = M.base_30.green,
    italic = true,
    link = "",
  },
  ["@include.go"] = {
    fg = M.base_30.dark_purple,
    link = "",
  },
  ["@namespace.go"] = {
    fg = M.base_30.white,
    link = "",
  },
  ["@constructor.lua"] = {
    fg = M.base_30.white,
    link = "",
  },
  DiagnosticUnderlineOk = {
    sp = M.base_30.vibrant_green,
    undercurl = true,
  },
  DiagnosticUnderlineInfo = {
    sp = M.base_30.green,
    undercurl = true,
  },
  DiagnosticUnderlineHint = {
    sp = M.base_30.purple,
    undercurl = true,
  },
  DiagnosticUnderlineWarn = {
    sp = M.base_30.yellow,
    undercurl = true,
  },
  DiagnosticUnderlineError = {
    sp = M.base_30.red,
    undercurl = true,
  },
  TSModuleInfoGood = {
    fg = M.base_30.green,
  },
  TSModuleInfoBad = {
    fg = M.base_30.red,
  },
  NvimTreeFolderIcon = {
    fg = M.base_30.orange,
  },
  NvimTreeOpenedFolderName = {
    fg = M.base_30.vibrant_green,
  },
}

return M
