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
    local c = vim.lsp.get_client_by_id(e.data.client_id)
    local v = e.data.result.value

    local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }
    local icon = spinners[1]
    if v.kind and v.kind == "end" then
      icon = spinners[#spinners]
    elseif not v.kind or v.kind ~= "begin" then
      if v.percentage then
        local frame = math.floor(v.percentage / (100 / (#spinners - 1)))
        icon = spinners[frame + 1]
      else
        -- one new spinner frame every 120 ms
        local ms = vim.uv.hrtime() / 1000000
        local frame = math.floor(ms / 120) % #spinners
        icon = spinners[frame + 1]
      end
    end

    local content = icon
    content = c and string.format("%s %s", content, c.name) or content
    content = v.title and string.format("%s [%s]", content, v.title) or content
    content = v.message and string.format("%s %s", content, v.message) or content
    content = v.percentage and string.format("%s (%s%%)", content, v.percentage) or content

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
