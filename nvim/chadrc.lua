---@type ChadrcConfig
local M = {}

local highlights = require "custom.highlights"

M.ui = {
  theme = "everforest",
  theme_toggle = { "everforest", "everforest_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  changed_themes = require "custom.themes",

  statusline = {
    overriden_modules = function()
      return require "custom.statusline"
    end,
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
