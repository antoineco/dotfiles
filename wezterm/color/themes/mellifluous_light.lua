local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#d5d5d5',  -- dark_bg2
    bg0    = '#ececec',  -- bg
    bg1    = '#ffffff',  -- bg4
    fg     = '#1b1b1b',  -- fg
    grey0  = '#686868',  -- fg3
    grey1  = '#919191'   -- fg4
  }
}

---@type Colors
local base = {
  ansi = {
    '#e5e5e5',  -- dark_bg
    '#b73242',  -- red
    '#63611e',  -- green
    '#a16927',  -- orange
    '#5a418a',  -- blue
    '#863e7f',  -- purple
    '#9c792a',  -- yellow
    '#686868'   -- fg3
  },
  brights = {
    '#d5d5d5',  -- dark_bg2
    '#990b2a',  -- red, darkened(10)
    '#4b4800',  -- green, darkened(10)
    '#865000',  -- orange, darkened(10)
    '#42286f',  -- blue, darkened(10)
    '#6b2465',  -- purple, darkened(10)
    '#815f00',  -- yellow, darkened
    '#414141'   -- fg2
  },

  foreground = '#1b1b1b',     -- fg
  background = '#ececec',     -- bg
  cursor_fg = '#ececec',      -- bg
  cursor_bg = '#1b1b1b',      -- fg
  cursor_border = '#1b1b1b',  -- fg
  selection_bg = '#fdfdfd',   -- bg3
  compose_cursor = '#7f67b3'  -- ui_blue
}
M:build(base)

return M
