local wezterm = require 'wezterm'
local scheme = require 'color.scheme'

---@type Scheme
local M = scheme:new {
  palette = {
    bg_dim = '#efebd4',  -- bg_dim medium
    bg0    = '#fffbef',  -- bg0 hard
    bg1    = '#ffffff',
    fg     = '#5c6a72',  -- fg
    grey0  = '#829181',  -- grey2
    grey1  = '#a6b0a0'   -- grey0
  }
}

---@type Colors
local base = wezterm.color.get_builtin_schemes()['Everforest Light Hard (Gogh)']
base.selection_bg = '#f0f2d4'
base.compose_cursor = '#dfa000'  -- yellow

-- Revert blacks/whites
local white, white_bright = base.ansi[1], base.brights[1]
local black, black_bright = base.ansi[8], base.brights[8]
base.ansi[1], base.brights[1] = black, black_bright
base.ansi[8], base.brights[8] = white, white_bright

M:build(base)

return M
