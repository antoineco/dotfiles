local M = {}

---@type table<string, Scheme>
local all = {
  ['Everforest']  = require 'color.themes.everforest',
  ['Mellifluous'] = require 'color.themes.mellifluous'
}

--- Returns a table containing all color schemes indexed by name.
---@return table<string, Scheme>
function M.list()
  return all
end

return M
