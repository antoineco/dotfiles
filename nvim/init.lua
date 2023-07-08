-- Neovim general settings
--

-- stylua: ignore start
vim.o.relativenumber = true  -- line numbers relative to cursor
vim.o.scrolloff = 8          -- number of lines to show above/below cursor
vim.o.colorcolumn = "+1"     -- highlight textwidth column
vim.o.clipboard = ""         -- no implicit interaction with clipboard register

vim.opt.wildmode = { 'longest',  -- 1st Tab completes till longest common string,
                     'full' }    -- 2nd Tab opens wildmenu
-- stylua: ignore end

-- NvChad settings
--

-- luasnip
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode"

-- Miscellaneous
--

-- LSP progress messages (Neovim 0.10+)
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("lsp_progress_notify", {}),
  callback = function(e)
    local v = e.data.result.value

    local kind = v.kind or ""
    local title = v.title or ""
    local message = v.message or ""
    local percentage = v.percentage or 0

    local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
    local ms = vim.uv.hrtime() / 1000000
    local icon = spinners[1]
    if kind == "end" then
      icon = spinners[#spinners]
    elseif kind ~= "begin" then
      local frame = math.floor(ms / 120) % #spinners
      icon = spinners[frame + 1]
    end

    local content = icon
    content = title ~= "" and string.format("%s [%s]", content, title) or content
    content = message ~= "" and string.format("%s %s", content, message) or content
    content = percentage > 0 and string.format("%s (%s%%)", content, percentage) or content

    vim.notify(content, vim.log.levels.INFO)
  end,
})

-- Toggle relative line numbers on focus change
local grpid = vim.api.nvim_create_augroup("toggle_rnu_on_focus", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = grpid,
  pattern = "*",
  callback = function()
    if vim.o.nu and vim.fn.mode() ~= "i" then
      vim.o.rnu = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = grpid,
  pattern = "*",
  callback = function()
    if vim.o.nu then
      vim.o.rnu = false
    end
  end,
})
