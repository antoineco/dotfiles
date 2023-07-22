---@type ChadrcConfig
local M = {}

local highlights = require "custom.highlights"

M.ui = {
  ---@diagnostic disable-next-line: assign-type-mismatch
  theme = "everforest_medium",
  ---@diagnostic disable-next-line: assign-type-mismatch
  theme_toggle = { "everforest_medium", "everforest_medium_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
    overriden_modules = function()
      return require "custom.statusline"
    end,
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
