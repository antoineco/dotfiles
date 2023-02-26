-- Neovim general settings
--

vim.o.timeoutlen = 500       -- time to wait for mapped sequences
vim.o.relativenumber = true  -- line numbers relative to cursor
vim.o.colorcolumn = '+1'     -- highlight textwidth column
vim.o.clipboard = ''         -- no implicit interaction with clipboard register

-- LunarVim general settings
--

lvim.leader = 'space'
lvim.colorscheme = 'everforest'

-- LunarVim core plugins
--

-- Enable all key hints.
-- Detail at https://github.com/folke/which-key.nvim/tree/v1.1.1/lua/which-key/plugins/presets
lvim.builtin.which_key.setup.plugins.marks = true
lvim.builtin.which_key.setup.plugins.registers = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.windows = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.g = true
lvim.builtin.which_key.setup.plugins.presets.z = true

-- Disable Git status icons in file tree. Git status is already indicated via syntax highlighting.
-- see |nvim-tree.renderer.icons.show.git|
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.treesitter.ensure_installed = {
  'bash',
  'c',
  'comment',
  'css',
  'go',
  'help',
  'java',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'tsx',
  'typescript',
  'regex',
  'rust',
  'vim',
  'yaml',
}

-- Additional Plugins
--

lvim.plugins = {
  { 'sainnhe/everforest',
    lazy = lvim.colorscheme ~= 'everforest',
    config = function()
      vim.g.everforest_enable_italic = true
    end,
  },
  { 'fatih/vim-go',
    ft = { 'go', 'gomod', 'gosum', 'gowork', 'gohtmltmpl', 'asm' },
    config = function()
      vim.g.go_gopls_enabled = false     -- gopls is managed by Neovim as a language server
      vim.g.go_fmt_autosave = false      -- formatting is delegated to the LSP server
      vim.g.go_imports_autosave = false  -- imports are delegated to the LSP server
    end,
  },
}

-- Miscellaneous
--

-- Apply custom highlights on colorscheme change.
-- Must be declared before executing ':colorscheme'.
local grpid = vim.api.nvim_create_augroup('custom_highlights_everforest', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = grpid,
  pattern = 'everforest',
  callback = function()
    -- go
    vim.api.nvim_set_hl(0, '@field.go', { link = 'Fg' })
  end
})

-- Toggle relative line numbers on focus change
grpid = vim.api.nvim_create_augroup('toggle_rnu_on_focus', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = grpid,
  pattern = '*',
  callback = function() if vim.o.nu and vim.fn.mode() ~= 'i' then vim.o.rnu = true end end
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = grpid,
  pattern = '*',
  callback = function() if vim.o.nu then vim.o.rnu = false end end
})

-- WSL clipboard fallback method
if vim.fn.has 'wsl' == 1 and vim.fn.executable 'win32yank.exe' ~= 1 then
  -- FIXME: those commands cause garbage in the terminal after each interaction with the Windows clipboard.
  local copy = { 'pwsh.exe', '-c',
    '$clip;' ..
    'foreach ($chunk in $input) {' ..
      '$clip += "$chunk$([System.Environment]::NewLine)"' ..
    '};' ..
    'Set-Clipboard $clip.Remove($clip.Length-[System.Environment]::NewLine.Length)'
  }

  local paste = { 'pwsh.exe', '-c',
    '(Get-Clipboard -Raw).Replace([System.Environment]::NewLine, "`n") | Write-Host -NoNewline'
  }

  vim.g.clipboard = {
    name = 'wsl',
    copy = {
      ['*'] = copy,
      ['+'] = copy
    },
    paste = {
      ['*'] = paste,
      ['+'] = paste
    },
    cache_enabled = 1
  }
end
