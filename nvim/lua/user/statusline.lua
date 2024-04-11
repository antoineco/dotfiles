-- NvChad default statusline style
-- https://github.com/NvChad/ui/blob/v2.0/lua/nvchad_ui/statusline/default.lua
local M = {}

-- highlight groups
M.set_highlights = function()
  if vim.g.colors_name == "everforest" then
    local config = vim.fn["everforest#get_configuration"]()
    local palette = vim.fn["everforest#get_palette"](config.background, config.colors_override)
    local set_hl = vim.fn["everforest#highlight"]

    set_hl("St_NormalMode", palette.bg0, palette.statusline1, "bold")
    set_hl("St_NormalModeSep", palette.statusline1, palette.bg4)
    set_hl("St_InsertMode", palette.bg0, palette.statusline2, "bold")
    set_hl("St_InsertModeSep", palette.statusline2, palette.bg4)
    set_hl("St_VisualMode", palette.bg0, palette.statusline3, "bold")
    set_hl("St_VisualModeSep", palette.statusline3, palette.bg4)
    set_hl("St_ReplaceMode", palette.bg0, palette.orange, "bold")
    set_hl("St_ReplaceModeSep", palette.orange, palette.bg4)
    set_hl("St_SelectMode", palette.bg0, palette.purple, "bold")
    set_hl("St_SelectModeSep", palette.purple, palette.bg4)
    set_hl("St_CommandMode", palette.bg0, palette.aqua, "bold")
    set_hl("St_CommandModeSep", palette.aqua, palette.bg4)
    set_hl("St_TerminalMode", palette.bg0, palette.yellow, "bold")
    set_hl("St_TerminalModeSep", palette.yellow, palette.bg4)
    set_hl("St_EmptySpace", palette.bg4, palette.bg2)
    set_hl("St_FileInfo", palette.grey2, palette.bg2)
    set_hl("St_FileSep", palette.bg2, palette.bg1)
    set_hl("St_GitIcons", palette.grey1, palette.bg1, "bold")
    set_hl("St_DiagError", palette.red, palette.bg1)
    set_hl("St_DiagWarning", palette.yellow, palette.bg1)
    set_hl("St_DiagHint", palette.green, palette.bg1)
    set_hl("St_DiagInfo", palette.blue, palette.bg1)
    set_hl("St_LspInfo", palette.blue, palette.bg1)
    set_hl("St_CwdSep", palette.purple, palette.bg1)
    set_hl("St_CwdIcon", palette.bg1, palette.purple)
    set_hl("St_CwdText", palette.grey2, palette.bg2)
    set_hl("St_PosSep", palette.aqua, palette.bg2)
    set_hl("St_PosIcon", palette.bg1, palette.aqua)
    set_hl("St_PosText", palette.grey2, palette.bg2)
  else
    local palette = ({
      light = {
        bg0 = "NvimLightGrey1",
        bg1 = "NvimLightGrey3",
        bg2 = "NvimLightGrey4",
        bg4 = "NvimDarkGrey4",
        grey1 = "NvimDarkGrey4",
        grey2 = "NvimDarkGrey3",
        beige = "NvimDarkGrey2",
        blue = "NvimDarkBlue",
        cyan = "NvimDarkCyan",
        green = "NvimDarkGreen",
        red = "NvimDarkRed",
        yellow = "NvimDarkYellow"
      },
      dark = {
        bg0 = "NvimDarkGrey1",
        bg1 = "NvimDarkGrey3",
        bg2 = "NvimDarkGrey4",
        bg4 = "NvimLightGrey4",
        grey1 = "NvimLightGrey4",
        grey2 = "NvimLightGrey3",
        beige = "NvimLightGrey2",
        blue = "NvimLightBlue",
        cyan = "NvimLightCyan",
        green = "NvimLightGreen",
        red = "NvimLightRed",
        yellow = "NvimLightYellow"
      }
    })[vim.o.background]

    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    set_hl("St_NormalMode", { fg = palette.bg0, bg = palette.green, bold = true })
    set_hl("St_NormalModeSep", { fg = palette.green, bg = palette.bg4 })
    set_hl("St_InsertMode", { fg = palette.bg0, bg = palette.blue, bold = true })
    set_hl("St_InsertModeSep", { fg = palette.blue, bg = palette.bg4 })
    set_hl("St_VisualMode", { fg = palette.bg0, bg = palette.cyan, bold = true })
    set_hl("St_VisualModeSep", { fg = palette.cyan, bg = palette.bg4 })
    set_hl("St_ReplaceMode", { fg = palette.bg0, bg = palette.red, bold = true })
    set_hl("St_ReplaceModeSep", { fg = palette.red, bg = palette.bg4 })
    set_hl("St_SelectMode", { fg = palette.bg0, bg = palette.yellow, bold = true })
    set_hl("St_SelectModeSep", { fg = palette.yellow, bg = palette.bg4 })
    set_hl("St_CommandMode", { fg = palette.bg0, bg = palette.beige, bold = true })
    set_hl("St_CommandModeSep", { fg = palette.beige, bg = palette.bg4 })
    set_hl("St_TerminalMode", { fg = palette.bg0, bg = palette.yellow, bold = true })
    set_hl("St_TerminalModeSep", { fg = palette.yellow, bg = palette.bg4 })
    set_hl("St_EmptySpace", { fg = palette.bg4, bg = palette.bg2 })
    set_hl("St_FileInfo", { fg = palette.grey2, bg = palette.bg2 })
    set_hl("St_FileSep", { fg = palette.bg2, bg = palette.bg1 })
    set_hl("St_GitIcons", { fg = palette.grey1, bg = palette.bg1, bold = true })
    set_hl("St_DiagError", { fg = palette.red, bg = palette.bg1 })
    set_hl("St_DiagWarning", { fg = palette.yellow, bg = palette.bg1 })
    set_hl("St_DiagHint", { fg = palette.green, bg = palette.bg1 })
    set_hl("St_DiagInfo", { fg = palette.blue, bg = palette.bg1 })
    set_hl("St_LspInfo", { fg = palette.blue, bg = palette.bg1 })
    set_hl("St_CwdSep", { fg = palette.cyan, bg = palette.bg1 })
    set_hl("St_CwdIcon", { fg = palette.bg1, bg = palette.cyan })
    set_hl("St_CwdText", { fg = palette.grey2, bg = palette.bg2 })
    set_hl("St_PosSep", { fg = palette.blue, bg = palette.bg2 })
    set_hl("St_PosIcon", { fg = palette.bg1, bg = palette.blue })
    set_hl("St_PosText", { fg = palette.grey2, bg = palette.bg2 })
  end
end

local modes = {
  ["n"] = { "NORMAL", "St_NormalMode" },
  ["no"] = { "NORMAL (no)", "St_NormalMode" },
  ["nov"] = { "NORMAL (nov)", "St_NormalMode" },
  ["noV"] = { "NORMAL (noV)", "St_NormalMode" },
  ["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
  ["niI"] = { "NORMAL i", "St_NormalMode" },
  ["niR"] = { "NORMAL r", "St_NormalMode" },
  ["niV"] = { "NORMAL v", "St_NormalMode" },
  ["nt"] = { "NTERMINAL", "St_TerminalMode" },
  ["ntT"] = { "NTERMINAL (ntT)", "St_TerminalMode" },

  ["v"] = { "VISUAL", "St_VisualMode" },
  ["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
  ["V"] = { "V-LINE", "St_VisualMode" },
  ["Vs"] = { "V-LINE", "St_VisualMode" },
  [""] = { "V-BLOCK", "St_VisualMode" },

  ["i"] = { "INSERT", "St_InsertMode" },
  ["ic"] = { "INSERT (completion)", "St_InsertMode" },
  ["ix"] = { "INSERT completion", "St_InsertMode" },

  ["t"] = { "TERMINAL", "St_TerminalMode" },

  ["R"] = { "REPLACE", "St_ReplaceMode" },
  ["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
  ["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

  ["s"] = { "SELECT", "St_SelectMode" },
  ["S"] = { "S-LINE", "St_SelectMode" },
  [""] = { "S-BLOCK", "St_SelectMode" },
  ["c"] = { "COMMAND", "St_CommandMode" },
  ["cv"] = { "COMMAND", "St_CommandMode" },
  ["ce"] = { "COMMAND", "St_CommandMode" },
  ["r"] = { "PROMPT", "St_ConfirmMode" },
  ["rm"] = { "MORE", "St_ConfirmMode" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode" },
  ["x"] = { "CONFIRM", "St_ConfirmMode" },
  ["!"] = { "SHELL", "St_TerminalMode" }
}

local sep_l = ""
local sep_r = " "

M.draw = function()
  local bufnr = vim.api.nvim_get_current_buf()

  -- mode
  local m = vim.api.nvim_get_mode().mode
  local current_mode = "%#" .. modes[m][2] .. "#" .. "  " .. modes[m][1] .. " "
  local mode_sep = "%#" .. modes[m][2] .. "Sep" .. "#" .. sep_r

  -- fileinfo
  local file_sep = "%#St_FileSep#" .. sep_r
  local ft_icon = require "nvim-web-devicons".get_icon(vim.fn.expand "%:t") or "󰈚"

  -- git
  local git_status = vim.b["gitsigns_status_dict"]
  local git = git_status and "%#St_GitIcons#" .. " " .. git_status.head .. " " ..
    (git_status.added and git_status.added > 0 and " " .. git_status.added .. " " or "") ..
    (git_status.changed and git_status.changed > 0 and " " .. git_status.changed .. " " or "") ..
    (git_status.removed and git_status.removed > 0 and " " .. git_status.removed .. " " or "") or ""

  -- diagnostics
  local diag_errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
  local diag_warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
  local diag_hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
  local diag_infos = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })

  local diags = (diag_errors > 0 and "%#St_DiagError#" .. " " .. diag_errors .. " " or "") ..
    (diag_warnings > 0 and "%#St_DiagWarning#" .. " " .. diag_warnings .. " " or "") ..
    (diag_hints > 0 and "%#St_DiagHint#" .. " " .. diag_hints .. " " or "") ..
    (diag_infos > 0 and "%#St_DiagInfo#" .. " " .. diag_infos .. " " or "")

  -- lsp
  local attached_clients = vim.lsp.get_clients { bufnr = bufnr }
  local lsp = #attached_clients > 0 and "%#St_LspInfo#" .. " " .. " " .. attached_clients[1].name .. " " or ""

  -- cwd
  local cwd_sep = "%#St_CwdSep#" .. sep_l .. "%#St_CwdIcon#" .. "󰉋 "
  local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  -- cursor
  local pos_sep = "%#St_PosSep#" .. sep_l .. "%#St_PosIcon#" .. " "

  return current_mode .. mode_sep ..
    "%#St_EmptySpace#" .. sep_r ..
    "%#St_FileInfo#" .. ft_icon .. " " .. "%t" .. " " .. "%-4m" .. file_sep ..
    git ..
    "%=" ..
    diags ..
    lsp ..
    cwd_sep .. "%#St_CwdText#" .. " " .. dir_name .. " " ..
    pos_sep .. "%#St_PosText#" .. " " .. "%3P:%-2v" .. " "
end

return M
