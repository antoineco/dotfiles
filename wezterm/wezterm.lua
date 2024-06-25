local wezterm = require 'wezterm'
local tab = require 'tab'
local color = require 'color'

local config = wezterm.config_builder()

color.setup(config)

-- Terminal
--

config.term = 'wezterm'

config.initial_cols = 120
config.bold_brightens_ansi_colors = false

config.exit_behavior = 'CloseOnCleanExit'

config.font = wezterm.font('MonoLisa', { weight = 'Regular' })
config.font_size = 12

-- Navigation
--

config.leader = { key = 'b', mods = 'CTRL' }

-- https://wezfurlong.org/wezterm/config/default-keys.html
config.keys = {
  {
    key = 'UpArrow',
    mods = 'SHIFT',
    action = wezterm.action.ScrollToPrompt(-1)
  },
  {
    key = 'DownArrow',
    mods = 'SHIFT',
    action = wezterm.action.ScrollToPrompt(1)
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  {
    key = ',',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new tab name',
      action = wezterm.action_callback(tab.set_title)
    }
  },
  {
    key = 'b',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'b', mods = 'CTRL' }
  },
  {
    key = 'L',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.ShowLauncher
  }
}

-- Launch
--

local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_domain = 'WSL:Ubuntu'

  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe' },
    domain = { DomainName = 'local' }
  })
end

config.launch_menu = launch_menu

-- Appearance
--

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 24

config.window_decorations = 'RESIZE'

local get_appearance = function()
  local gui_appearance = wezterm.gui and wezterm.gui.get_appearance() or ''
  return gui_appearance:sub(1, 1) == 'L' and 'Light' or 'Dark'
end

local colorscheme = 'Mellifluous ' .. get_appearance()

config.color_scheme = colorscheme

local palette = require 'color'.palette(colorscheme)
wezterm.on('format-tab-title', tab.slanted_tmux(palette))

return config
