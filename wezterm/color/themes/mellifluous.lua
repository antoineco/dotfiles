local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#191919',
    bg0    = '#282828',
    bg1    = '#323232',
    bg_vis = '#2D2D2D',
    fg     = '#DADADA',
    alt    = '#938CA8',  -- ui_blue
    grey0  = '#848484',
    grey1  = '#AEAEAE'
  }
}

---@type Colors
local base = wezterm.color.get_builtin_schemes()['Mellifluous']
base.background = '#1F1F1F'  -- soft
base.selection_fg = nil
M:build(base)

return M
