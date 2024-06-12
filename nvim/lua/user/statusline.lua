local M = {}

-- highlight groups
M.set_highlights = function()
  if vim.g.colors_name == "everforest" then
    local set_hl = vim.fn["everforest#highlight"]

    local function get_fg(name)
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      return { ("#%06x"):format(hl.fg), ("%d"):format(hl.ctermfg) }
    end

    local st_bg = (function()
      local hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
      return { ("#%06x"):format(hl.bg), ("%d"):format(hl.ctermbg) }
    end)()

    set_hl("User1", get_fg "Added", st_bg)
    set_hl("User2", get_fg "Changed", st_bg)
    set_hl("User3", get_fg "Removed", st_bg)
    set_hl("User4", get_fg "DiagnosticSignError", st_bg)
    set_hl("User5", get_fg "DiagnosticSignWarn", st_bg)
    set_hl("User6", get_fg "DiagnosticSignHint", st_bg)
    set_hl("User7", get_fg "DiagnosticSignInfo", st_bg)
  elseif vim.g.colors_name == "mellifluous" then
    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    local highlighter = require "mellifluous.utils.highlighter"

    local function get_fg(name)
      return highlighter.get(name).fg
    end

    local st_bg = highlighter.get "StatusLine".bg

    set_hl("User1", { fg = get_fg "Added", bg = st_bg })
    set_hl("User2", { fg = get_fg "Changed", bg = st_bg })
    set_hl("User3", { fg = get_fg "Removed", bg = st_bg })
    set_hl("User4", { fg = get_fg "DiagnosticSignError", bg = st_bg })
    set_hl("User5", { fg = get_fg "DiagnosticSignWarn", bg = st_bg })
    set_hl("User6", { fg = get_fg "DiagnosticSignHint", bg = st_bg })
    set_hl("User7", { fg = get_fg "DiagnosticSignInfo", bg = st_bg })
  elseif vim.g.colors_name == "default" then
    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    local st_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg

    -- Reading the fg color from DiagnosticSignXYZ highlight groups doesn't
    -- work in the default colorscheme, because StatusLine has a light
    -- background in dark mode, and inversely in light mode.
    local diag_colors = ({
      dark = {
        added = "NvimDarkGreen",
        changed = "NvimDarkCyan",
        removed = "NvimDarkRed",
        error = "NvimDarkRed",
        warn = "NvimDarkYellow",
        hint = "NvimDarkBlue",
        info = "NvimDarkCyan"
      },
      light = {
        added = "NvimLightGreen",
        changed = "NvimLightCyan",
        removed = "NvimLightRed",
        error = "NvimLightRed",
        warn = "NvimLightYellow",
        hint = "NvimLightBlue",
        info = "NvimLightCyan"
      }
    })[vim.o.background]

    set_hl("User1", { fg = diag_colors.added, bg = st_bg })
    set_hl("User2", { fg = diag_colors.changed, bg = st_bg })
    set_hl("User3", { fg = diag_colors.removed, bg = st_bg })
    set_hl("User4", { fg = diag_colors.error, bg = st_bg })
    set_hl("User5", { fg = diag_colors.warn, bg = st_bg })
    set_hl("User6", { fg = diag_colors.hint, bg = st_bg })
    set_hl("User7", { fg = diag_colors.info, bg = st_bg })
  else
    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    local function get_fg(name)
      return vim.api.nvim_get_hl(0, { name = name, link = false }).fg
    end

    local st_bg = (function()
      local hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
      return hl.reverse and hl.fg or hl.bg
    end)()

    set_hl("User1", { fg = get_fg "Added", bg = st_bg })
    set_hl("User2", { fg = get_fg "Changed", bg = st_bg })
    set_hl("User3", { fg = get_fg "Removed", bg = st_bg })
    set_hl("User4", { fg = get_fg "DiagnosticSignError", bg = st_bg })
    set_hl("User5", { fg = get_fg "DiagnosticSignWarn", bg = st_bg })
    set_hl("User6", { fg = get_fg "DiagnosticSignHint", bg = st_bg })
    set_hl("User7", { fg = get_fg "DiagnosticSignInfo", bg = st_bg })
  end

  -- HACK: restoring the StatusLine highlight with "%*" at the end of a "%()"
  -- item group causes the item group to disappear unconditionally. This is
  -- possibly a bug in Neovim (neovim/neovim#29306). The item group should only
  -- disappear when all items inside the group are empty (:h 'statusline').
  -- This can be mitigated by applying a numbered User highlight before every
  -- group item that expands a restore item.
  vim.api.nvim_set_hl(0, "User9", vim.api.nvim_get_hl(0, { name = "StatusLine" }))
end

M.draw = function()
  return
    "%{v:lua.St.mode()}" ..
    "%(   %{%v:lua.St.filename()%}%)" ..
    "%(   %{v:lua.St.git_head()}%)%9*%( [%{%v:lua.St.git_status()%}]%)" ..
    "%=" ..
    "%(%{v:lua.St.lsp_server()}%)%9*%( [%{%v:lua.St.lsp_diags()%}]%)" ..
    "%14(%P:%c%V%)"
end

M.mode = function()
  -- :h mode()
  return ({
    ["n"] = "NOR",
    ["no"] = "NOo",
    ["nov"] = "NOv",
    ["noV"] = "NOV",
    ["no^V"] = "NO?",
    ["niI"] = "NOi",
    ["niR"] = "NiR",
    ["niV"] = "NiV",
    ["nt"] = "NOt",
    ["ntT"] = "NtT",

    ["v"] = "VIS",
    ["vs"] = "VIs",
    ["V"] = "VIl",
    ["Vs"] = "VIs",
    [""] = "VIb",

    ["i"] = "INS",
    ["ic"] = "INc",
    ["ix"] = "INx",

    ["t"] = "TER",

    ["R"] = "REP",
    ["Rc"] = "REc",
    ["Rx"] = "REx",
    ["Rv"] = "REv",
    ["Rvc"] = "Rvc",
    ["Rvx"] = "Rvx",

    ["s"] = "SEL",
    ["S"] = "SEl",
    [""] = "SEb",

    ["c"] = "CMD",
    ["cv"] = "COv",
    ["ce"] = "COe",

    ["r"] = "...",
    ["rm"] = "..m",
    ["r?"] = "?  ",
    ["!"] = "!  "
  })[vim.api.nvim_get_mode().mode]
end

M.filename = function()
  local ft_icon = require "nvim-web-devicons".get_icon(vim.fn.expand "%:t") or "󰈚"
  return ft_icon .. " %t%( %m%)%)"
end

M.git_head = function()
  local gs = vim.b.gitsigns_status_dict
  return gs and " " .. gs.head or ""
end

M.git_status = function()
  local gs = vim.b.gitsigns_status_dict
  if not gs then
    return ""
  end

  local status = {}

  if gs.added and gs.added > 0 then
    table.insert(status, "%1*◆" .. gs.added)
  end
  if gs.changed and gs.changed > 0 then
    table.insert(status, "%2*●" .. gs.changed)
  end
  if gs.removed and gs.removed > 0 then
    table.insert(status, "%3*▼" .. gs.removed)
  end

  return #status > 0 and table.concat(status, "%* ") .. "%*" or ""
end

M.lsp_server = function()
  local attached_clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
  return #attached_clients > 0 and " " .. attached_clients[1].name or ""
end

M.lsp_diags = function()
  local diag_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local diag_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local diag_hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local diag_infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local diags = {}

  if diag_errors > 0 then
    table.insert(diags, "%4*◆" .. diag_errors)
  end
  if diag_warnings > 0 then
    table.insert(diags, "%5*▼" .. diag_warnings)
  end
  if diag_hints > 0 then
    table.insert(diags, "%6*●" .. diag_hints)
  end
  if diag_infos > 0 then
    table.insert(diags, "%7*■" .. diag_infos)
  end

  return #diags > 0 and table.concat(diags, "%* ") .. "%*" or ""
end

return M
