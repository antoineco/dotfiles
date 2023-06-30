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
