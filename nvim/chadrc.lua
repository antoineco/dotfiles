---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "everforest",
  theme_toggle = { "everforest", "everforest_light" },

  statusline = {
    overriden_modules = function()
      return require "custom.statusline"
    end,
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
