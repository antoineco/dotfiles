local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#232a2e',
    bg0    = '#2d353b',
    bg1    = '#343f44',
    fg     = '#d3c6aa',
    grey0  = '#7a8478',
    grey1  = '#859289'
  }
}

---@type Colors
local base = wezterm.color.get_builtin_schemes()['Everforest Dark Medium (Gogh)']
base.selection_bg = '#543a48'
base.compose_cursor = '#dbbc7f'  -- yellow
M:build(base)

return M
