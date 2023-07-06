---@type Base46Table
local M = {}

M.type = "light"

-- stylua: ignore
M.base_30 = {
  white         = "#272f35",
  darker_black  = "#efebd4", -- LSP/cmp pop-ups, tree bg
  black         = "#fdf6e3", -- cmp bg, icons/headers fg
  black2        = "#f4f0d9", -- tabline bg, cursor lines, selections
  one_bg        = "#f4f0d9", -- pop-up menu bg, statusline icon fg
  one_bg2       = "#efebd4", -- tabline inactive bg, indent line context start
  one_bg3       = "#e6e2cc", -- tabline toggle/new btn, borders
  grey          = "#e0dcc7", -- line nr, scrollbar, indent line hover
  grey_fg       = "#a6b0a0", -- comment
  grey_fg2      = "#00ffff", -- unused
  light_grey    = "#857F6E", -- diff change, tabline inactive fg
  line          = "#efebd4", -- win sep, indent line
  statusline_bg = "#f4f0d9", -- statusline
  lightbg       = "#e6e2cc", -- statusline components
  pmenu_bg      = "#35a77c", -- pop-up menu selection
  folder_bg     = "#747b6e", -- tree items
  red           = "#f85552", -- diff delete, diag error
  pink          = "#ef6590", -- indicators
  baby_pink     = "#ce8196", -- dev icons
  green         = "#5da111", -- diff add, diag info, indicators
  vibrant_green = "#8da101", -- dev icons
  orange        = "#f57d26", -- diff mod
  yellow        = "#dfa000", -- diag warn
  sun           = "#d1b171", -- dev icons
  blue          = "#3a94c5", -- ui elements, dev/cmp icons
  nord_blue     = "#656c5f", -- indicators
  purple        = "#df69ba", -- diag hint, dev/cmp icons
  dark_purple   = "#966986", -- dev icons
  teal          = "#69a59d", -- dev/cmp icons
  cyan          = "#89bfdc", -- dev/cmp icons
}

M.base_16 = {
  base00 = "#fdf6e3", -- bg
  base01 = "#f4f0d9", -- fold bg
  base02 = "#efebd4", -- visual
  base03 = "#e6e2cc", -- special keys, signs, fold fg
  base04 = "#e0dcc7", -- def underline
  base05 = "#5c6a72", -- fg, var, operator, ref, txt
  base06 = "#00ffff", -- unused
  base07 = "#495156", -- cmp icons
  base08 = "#3a94c5", -- const, char, identifier, field, namespace, error, spell
  base09 = "#df69ba", -- num, bool, builtin const/var, uri, inc search
  base0A = "#35a77c", -- attribute, type, repeat, tag, todo, search, wild bg
  base0B = "#dfa000", -- string, symbol
  base0C = "#f57d26", -- constructor, special, regex, fold column
  base0D = "#8da101", -- func
  base0E = "#f85552", -- keyword
  base0F = "#df69ba", -- delimiter, special char
}

--- Off base46 palette
---@type table<string, string>
local extras = {
  bg_visual = "#eaedc8",
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
}

return M
