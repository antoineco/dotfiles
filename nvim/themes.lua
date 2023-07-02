local M = {}

---@alias ColorTable table<string, string>

---@type table<string, ColorTable>
local theme_colors = {
  -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/themes/everforest.lua
  -- stylua: ignore
  everforest = {
    white         = "#d3c6aa",
    grey_fg       = "#545c62",
    green         = "#83c092",
    vibrant_green = "#a7c080",
    yellow        = "#dbbc7f",
    orange        = "#e69875",
    red           = "#e67e80",
    purple        = "#ecafcc",
    dark_purple   = "#d699b6",
    -- off base46 palette
    bg_visual     = "#4c3743",
  },
  -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/themes/everforest_light.lua
  -- stylua: ignore
  everforest_light = {
    white         = "#272f35",
    grey_fg       = "#A39D8C",
    green         = "#5da111",
    vibrant_green = "#87a060",
    yellow        = "#dfa000",
    orange        = "#F7954F",
    red           = "#c85552",
    purple        = "#b67996",
    dark_purple   = "#966986",
    -- off base46 palette
    bg_visual     = "#f0f2d4",
  },
}

---@param colors ColorTable
---@return HLTable
local function everforest_hl_common(colors)
  return {
    Repeat = {
      fg = colors.red,
    },
    String = {
      fg = colors.green,
    },
    Tag = {
      fg = colors.orange,
    },
    Type = {
      fg = colors.yellow,
      italic = true,
    },
    Typedef = {
      fg = colors.yellow,
      italic = true,
    },
    Visual = {
      bg = colors.bg_visual,
    },
    ["@constant"] = {
      fg = colors.white,
    },
    ["@operator"] = {
      fg = colors.orange,
    },
    ["@punctuation.bracket"] = {
      fg = colors.white,
    },
    ["@punctuation.delimiter"] = {
      fg = colors.grey_fg,
      link = "",
    },
    ["@string"] = {
      fg = colors.green,
    },
    ["@tag"] = {
      fg = "",
    },
    ["@tag.delimiter"] = {
      fg = colors.vibrant_green,
    },
    ["@type.builtin"] = {
      fg = colors.yellow,
      italic = true,
    },
    ["@constant.builtin.go"] = {
      fg = colors.green,
      italic = true,
      link = "",
    },
    ["@include.go"] = {
      fg = colors.dark_purple,
      link = "",
    },
    ["@namespace.go"] = {
      fg = colors.white,
      link = "",
    },
    ["@constructor.lua"] = {
      fg = colors.white,
      link = "",
    },
    DiagnosticUnderlineOk = {
      sp = colors.vibrant_green,
      undercurl = true,
    },
    DiagnosticUnderlineInfo = {
      sp = colors.green,
      undercurl = true,
    },
    DiagnosticUnderlineHint = {
      sp = colors.purple,
      undercurl = true,
    },
    DiagnosticUnderlineWarn = {
      sp = colors.yellow,
      undercurl = true,
    },
    DiagnosticUnderlineError = {
      sp = colors.red,
      undercurl = true,
    },
  }
end

---@param colors ColorTable
---@return HLTable
local function everforest_hl(colors)
  return vim.tbl_extend("force", everforest_hl_common(colors), {
    NvimTreeFolderIcon = {
      fg = colors.orange,
    },
    NvimTreeFolderName = {
      fg = colors.green,
    },
    NvimTreeOpenedFolderName = {
      fg = colors.vibrant_green,
    },
  })
end

---@type Base46Table
M.everforest = {
  polish_hl = everforest_hl(theme_colors.everforest),
}

---@type Base46Table
M.everforest_light = {
  polish_hl = everforest_hl_common(theme_colors.everforest_light),
}

return M
