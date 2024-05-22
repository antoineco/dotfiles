local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#232A2E',
    bg0    = '#2D353B',
    bg1    = '#343F44',
    fg     = '#D3C6AA',
    grey0  = '#7A8478',
    grey1  = '#859289'
  }
}

---@type Colors
local base = wezterm.color.get_builtin_schemes()['Everforest Dark (Gogh)']
base.selection_bg = '#543A48'
base.compose_cursor = '#DBBC7F'  -- yellow
M:build(base)

return M
