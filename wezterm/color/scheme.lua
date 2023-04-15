---@class Scheme
---@field palette Palette
---@field colorscheme Colors
local M = {}

---@class Palette
---@field bg_dim string
---@field bg0    string
---@field bg1    string
---@field bg_vis string
---@field fg     string
---@field yellow string
---@field grey0  string
---@field grey1  string

--- A colors table, as embedded inside the wezterm config.
--- https://wezfurlong.org/wezterm/config/lua/config/colors.html
---@class Colors
---@field foreground? string
---@field background? string
---@field cursor_bg? string
---@field cursor_fg? string
---@field cursor_border? string
---@field compose_cursor? string
---@field selection_fg? string
---@field selection_bg? string
---@field scrollbar_thumb? string
---@field split? string
---@field ansi? string[]
---@field brights? string[]
---@field tab_bar? ColorsTabBar

---@class ColorsTabBar
---@field background? string
---@field active_tab? ColorsTabBarTab
---@field inactive_tab? ColorsTabBarTab
---@field inactive_tab_hover? ColorsTabBarTab
---@field new_tab? ColorsTabBarTab
---@field new_tab_hover? ColorsTabBarTab

---@class ColorsTabBarTab
---@field bg_color? string
---@field fg_color? string
---@field intensity? string
---@field underline? string
---@field italic? boolean
---@field strikethrough? boolean

--- Instantiates a new Scheme.
---@param scheme? Scheme
---@return Scheme
function M:new(scheme)
  scheme = scheme or {}
  setmetatable(scheme, self)
  self.__index = self
  return scheme
end

--- Builds the Scheme's colorscheme from the Scheme's palette.
--- Augments the given base colorscheme if provided.
---@param base? Colors
function M:build(base)
  self.colorscheme = base or {}

  if not self.palette then
    error('called Scheme:build() without initializing its palette')
  end

  self.colorscheme.cursor_fg = self.palette.bg0
  self.colorscheme.compose_cursor = self.palette.yellow

  self.colorscheme.selection_bg = self.palette.bg_vis

  self.colorscheme.tab_bar = {
    background = self.palette.bg_dim,

    new_tab = {
      bg_color = self.palette.bg_dim,
      fg_color = self.palette.grey0
    },
    new_tab_hover = {
      bg_color = self.palette.bg1,
      fg_color = self.palette.grey1
    }
  }
end

return M
