-- ====================== UI ======================

vim.opt.number = true       -- display line numbers
vim.opt.scrolloff = 5       -- number of lines to show above/below cursor
vim.opt.laststatus = 3      -- always show status line, only active window
vim.opt.colorcolumn = '+1'  -- highlight textwidth column

-- ================== Behaviour ===================

vim.g.mapleader = ','      -- more accessible leader key
vim.opt.splitbelow = true  -- open horizontal split below
vim.opt.splitright = true  -- open vertical split to the right
vim.opt.smartcase = true   -- make search case sensitive when pattern contains uppercase chars
vim.opt.ignorecase = true  -- required by smartcase
vim.opt.autowrite = true   -- automatically write buffer on commands like :next

vim.opt.wildmode = { 'list:longest',  -- 1st Tab completes till longest common string,
                     'list:full' }    -- 2nd Tab opens wildmenu

-- ============ Plugin customizations =============

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/settings.vim')

-- ================= Lua plugins ==================

require'nvim-web-devicons'.setup{
  default = true
}

require'nvim-tree'.setup()

-- ========== Providers and Integrations ==========

-- Neovim's assigned virtualenv for python3 provider (':h python-virtualenv')
vim.g.python3_host_prog = '~/.local/share/nvim/py3venv/bin/python3'

-- ================== Appearance ==================

vim.opt.termguicolors = true  -- enable 24-bit true color

vim.cmd'packadd! everforest'
vim.opt.background = 'dark'
vim.cmd'colorscheme everforest'
