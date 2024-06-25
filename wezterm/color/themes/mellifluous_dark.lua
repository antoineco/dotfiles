local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#191919',
    bg0    = '#282828',
    bg1    = '#323232',
    fg     = '#dadada',
    grey0  = '#848484',
    grey1  = '#aeaeae'
  }
}

---@type Colors
local base = wezterm.color.get_builtin_schemes()['Mellifluous']
base.background = '#1f1f1f'      -- soft
base.brights[1] = '#4d4d4d'      -- fg5
base.selection_bg = '#2f2f2f'    -- bg3
base.selection_fg = nil
base.compose_cursor = '#938ca8'  -- ui_blue
M:build(base)

return M
