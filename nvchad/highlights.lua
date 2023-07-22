local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = { italic = true },
}

---@type HLTable
--- All the highlight groups which "base46.integrations" does not include must
--- be explicitly declared here.
M.add = {
  CurSearch = { link = "IncSearch" },
  ["@constructor.lua"] = { link = "@constructor" },
  ["@constant.builtin.go"] = { link = "@constant.builtin" },
  ["@include.go"] = { link = "@include" },
  ["@namespace.go"] = { link = "@namespace" },
  DiagnosticUnderlineOk = { sp = "LightGreen", underline = true },
  DiagnosticUnderlineInformation = { sp = "LightBlue", underline = true },
  DiagnosticUnderlineHint = { sp = "LightGrey", underline = true },
  DiagnosticUnderlineWarn = { sp = "Orange", underline = true },
  DiagnosticUnderlineError = { sp = "Red", underline = true },
  TSModuleInfoGood = { fg = "LightGreen", bold = true },
  TSModuleInfoBad = { fg = "Crimson" },
}

return M
