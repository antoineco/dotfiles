local wezterm = require 'wezterm'

local M = {}

--- A wezterm Window.
--- https://wezfurlong.org/wezterm/config/lua/window/index.html
---@class Window
---@field active_tab fun(window: Window): MuxTab

--- A wezterm PaneInformation.
--- https://wezfurlong.org/wezterm/config/lua/PaneInformation.html
---@class PaneInformation
---@field title string

--- A wezterm MuxTab.
--- https://wezfurlong.org/wezterm/config/lua/MuxTab/index.html
---@class MuxTab
---@field set_title fun(tab: MuxTab, title: string)

--- A wezterm TabInformation.
--- https://wezfurlong.org/wezterm/config/lua/TabInformation.html
---@class TabInformation
---@field tab_id integer
---@field tab_index integer
---@field is_active boolean
---@field active_pane PaneInformation
---@field tab_title string

--- Sets the title of the active tab.
---@param window Window
---@param input string
function M.set_title(window, _, input)
  if input then
    window:active_tab():set_title(input)
  end
end

--- Returns the suggested title for a tab.
--- It prefers the title that was set via `tab:set_title()`
--- or `wezterm cli set-tab-title`, but falls back to the
--- title of the active pane in that tab.
---@param tab TabInformation
---@return string
local function get_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end

  return tab.active_pane.title
end

--- Returns whether the given tab is the last one in the
--- current window.
---@param tab TabInformation
---@param tabs TabInformation[]
---@return boolean
local function is_last_tab(tab, tabs)
  return #tabs <= 1 or tab.tab_index + 1 == #tabs
end

-- Returns whether the tab directly following the given one
-- in the current window is active.
---@param tab TabInformation
---@param tabs TabInformation[]
---@return boolean
local function is_next_tab_active(tab, tabs)
  if tab.is_active or is_last_tab(tab, tabs) then
    return false
  end

  return tabs[tab.tab_index + 2].is_active
end

--- A wezterm FormatItem.
--- https://wezfurlong.org/wezterm/config/lua/wezterm/format.html
---@class FormatItem
---@field Background? FormatItemColor
---@field Foreground? FormatItemColor
---@field Text? string

---@class FormatItemColor
---@field Color string

--- Returns a tab rendering function which generates tabs in
--- a tmux-like slanted style.
---@param palette Palette
---@return function
function M.slanted_tmux(palette)
  local edge_left_separator = ' '
  local edge_right_separator = wezterm.nerdfonts.ple_upper_left_triangle

  local tab_bar_background = palette.bg_dim
  local inactive_background = palette.bg0
  local active_background = palette.bg1

  ---@param tab TabInformation
  ---@param tabs TabInformation[]
  ---@param hover boolean
  ---@param max_width integer
  ---@return string|FormatItem[]
  return function (tab, tabs, _, _, hover, max_width)
    local background = inactive_background
    local foreground = palette.grey0
    if tab.is_active then
      background = active_background
      foreground = palette.fg
    elseif hover then
      background = palette.bg1
      foreground = palette.grey1
    end

    local edge_background = tab_bar_background
    if not is_last_tab(tab, tabs) then
      edge_background = is_next_tab_active(tab, tabs) and active_background or inactive_background
    end

    local edge_foreground = background

    local title = tab.tab_index + 1 .. ':' .. get_title(tab)

    -- Ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 3)

    return {
      { Background = { Color = background } },
      { Text = edge_left_separator },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title .. ' '},
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = edge_right_separator },
    }
  end
end

return M
