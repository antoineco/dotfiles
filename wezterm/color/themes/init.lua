local M = {}

---@type table<string, Scheme>
local all = {
  ['Everforest Dark']   = require 'color.themes.everforest_dark',
  ['Everforest Light']  = require 'color.themes.everforest_light',
  ['Mellifluous Dark']  = require 'color.themes.mellifluous_dark',
  ['Mellifluous Light'] = require 'color.themes.mellifluous_light'
}

--- Returns a table containing all color schemes indexed by name.
---@return table<string, Scheme>
function M.list()
  return all
end

return M
