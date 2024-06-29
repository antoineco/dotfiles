local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#191919',  -- dark_bg
    bg0    = '#282828',  -- bg2
    bg1    = '#323232',  -- bg4
    fg     = '#dadada',  -- fg
    grey0  = '#848484',  -- fg3
    grey1  = '#aeaeae'   -- fg2
  }
}

---@type Colors
local base = {
  ansi = {
    '#323232',  -- bg4
    '#d59192',  -- red
    '#b3b393',  -- green
    '#cbaa88',  -- orange
    '#a8a1be',  -- blue
    '#b99bb5',  -- purple
    '#bfaf8e',  -- yellow
    '#f1f1f1'   -- fg, lightened(8)
  },
  brights = {
    '#373737',  -- bg5
    '#f2acad',  -- red, lightened(10)
    '#cecfae',  -- green, lightened(10)
    '#e7c5a3',  -- orange, lightened(10)
    '#c3bcda',  -- blue, lightened(10)
    '#d5b6d1',  -- purple, lightened(10)
    '#dbcaa9',  -- yellow, lightened(10)
    '#fcfcfc'   -- fg, lightened(12)
  },

  foreground = '#dadada',     -- fg
  background = '#1f1f1f',     -- bg
  cursor_fg = '#1f1f1f',      -- bg
  cursor_bg = '#dadada',      -- fg
  cursor_border = '#dadada',  -- fg
  selection_bg = '#2d2d2d',   -- bg3
  compose_cursor = '#938ca8'  -- ui_blue
}
M:build(base)

return M
