local M = {}

--- A wezterm config table.
--- https://wezfurlong.org/wezterm/config/lua/config/index.html
---@class Config
---@field color_schemes table<string, Colors>

--- Injects custom color schemes into the given wezterm config.
---@param config Config
function M.setup(config)
  config.color_schemes = config.color_schemes or {}

  for k, v in pairs(require 'color.themes'.list()) do
    config.color_schemes[k] = v.colorscheme
  end
end

--- Returns the color palette of the given color scheme.
---@param name string
---@return Palette
function M.palette(name)
  return (require 'color.themes'.list()[name] or {}).palette
end

return M
