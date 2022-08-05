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

-- ===================== LSP ======================

-- Diagnostics mappings (':h vim.diagnostic')
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Callback for setting buffer local options upon attaching a buffer to a
-- language server (':h lspconfig-setup')
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o> (':h compl-omni')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Buffer local mappings (':h lsp-buf')
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  settings = {
    -- https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
    gopls = {
      analyses = {
        unusedparams = true
      }
    }
  }
}

-- ========== Providers and Integrations ==========

-- Neovim's assigned virtualenv for python3 provider (':h python-virtualenv')
vim.g.python3_host_prog = '~/.local/share/nvim/py3venv/bin/python3'

-- ================== Appearance ==================

vim.opt.termguicolors = true  -- enable 24-bit true color

vim.cmd'packadd! everforest'
vim.opt.background = 'dark'
vim.cmd'colorscheme everforest'
