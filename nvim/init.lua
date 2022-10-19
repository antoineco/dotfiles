-- ====================== UI ======================

vim.opt.number = true          -- display line numbers
vim.opt.relativenumber = true  -- line numbers relative to cursor
vim.opt.scrolloff = 5          -- number of lines to show above/below cursor
vim.opt.laststatus = 3         -- always show status line, only active window
vim.opt.colorcolumn = '+1'     -- highlight textwidth column

local grpid = vim.api.nvim_create_augroup('nvim_init', {})
-- Toggle relative line numbers on focus change
vim.api.nvim_create_autocmd({'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter'}, {
  group = grpid,
  pattern = '*',
  callback = function() if vim.o.nu and vim.fn.mode() ~= 'i' then vim.o.rnu = true end end
})
vim.api.nvim_create_autocmd({'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave'}, {
  group = grpid,
  pattern = '*',
  callback = function() if vim.o.nu then vim.o.rnu = false end end
})

-- ================== Behaviour ===================

vim.g.mapleader = ','      -- more accessible leader key
vim.opt.splitbelow = true  -- open horizontal split below
vim.opt.splitright = true  -- open vertical split to the right
vim.opt.smartcase = true   -- make search case sensitive when pattern contains uppercase chars
vim.opt.ignorecase = true  -- required by smartcase
vim.opt.autowrite = true   -- automatically write buffer on commands like :next
vim.opt.mouse = ''         -- disable mouse support

vim.opt.completeopt = { 'menu',       -- show completions in popup menu
                        'menuone',    -- ... even if there is only one match
                        'noselect' }  -- do not auto-select completion candidate

vim.opt.wildmode = { 'list:longest',  -- 1st Tab completes till longest common string,
                     'list:full' }    -- 2nd Tab opens wildmenu

-- ==================== Plugins ===================

require'plugins'

-- WebDevicons --

require'nvim-web-devicons'.setup{
  default = true
}

-- Tree --

require'nvim-tree.view'.View.winopts.cursorline = true
require'nvim-tree'.setup()

local opts = { remap=false, silent=true }
vim.keymap.set('n', '<Leader>n', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<Leader>f', ':NvimTreeFindFile!<CR>', opts)

-- Lightline --

vim.g.lightline = {
  active = {
    left  = { { 'mode', 'paste' }, { 'readonly', 'fugitive', 'filename', 'modified' } },
    right = { { 'lineinfo' }, { 'percent' }, { 'fileformat', 'fileencoding', 'filetype' }, { 'go' } }
  },
  component_function = {
    mode         = 'statusline#lightline#Mode',
    fugitive     = 'statusline#lightline#Fugitive',
    go           = 'statusline#lightline#Go',
    filename     = 'statusline#lightline#Filename',
    fileformat   = 'statusline#lightline#Fileformat',
    fileencoding = 'statusline#lightline#Fileencoding',
    filetype     = 'statusline#lightline#Filetype',
    percent      = 'statusline#lightline#Percent',
    lineinfo     = 'statusline#lightline#Lineinfo'
  },
  separator = { left = '', right = '' },
  subseparator = { left = '', right = '' }
}

-- Reload lightline on colorscheme change.
-- Must be declared before executing ':colorscheme'.
grpid = vim.api.nvim_create_augroup('lightline_reload_colorscheme', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = grpid,
  pattern = '*',
  command = 'call nviminit#lightline#SetColorscheme() | ' ..
            'call nviminit#lightline#Reload()'
})

-- Vim Go --

vim.g.go_gopls_enabled = false     -- gopls is managed by Neovim as a language server
vim.g.go_fmt_autosave = false      -- formatting is delegated to the LSP server
vim.g.go_imports_autosave = false  -- imports are delegated to the LSP server

-- Searchhi --

-- mappings, from the vim-searchhi README
vim.keymap.set('n', 'n', '<Plug>(searchhi-n)')
vim.keymap.set('n', 'N', '<Plug>(searchhi-N)')
vim.keymap.set('n', '*', '<Plug>(searchhi-*)')
vim.keymap.set('n', 'g*', '<Plug>(searchhi-g*)')
vim.keymap.set('n', '#', '<Plug>(searchhi-#)')
vim.keymap.set('n', 'g#', '<Plug>(searchhi-g#)')
vim.keymap.set('n', 'gd', '<Plug>(searchhi-gd)')
vim.keymap.set('n', 'gD', '<Plug>(searchhi-gD)')

vim.keymap.set('v', 'n', '<Plug>(searchhi-v-n)')
vim.keymap.set('v', 'N', '<Plug>(searchhi-v-N)')
vim.keymap.set('v', '*', '<Plug>(searchhi-v-*)')
vim.keymap.set('v', 'g*', '<Plug>(searchhi-v-g*)')
vim.keymap.set('v', '#', '<Plug>(searchhi-v-#)')
vim.keymap.set('v', 'g#', '<Plug>(searchhi-v-g#)')
vim.keymap.set('v', 'gd', '<Plug>(searchhi-v-gd)')
vim.keymap.set('v', 'gD', '<Plug>(searchhi-v-gD)')

vim.keymap.set('n', '<C-L>', '<Plug>(searchhi-clear-all)')
vim.keymap.set('v', '<C-L>', '<Plug>(searchhi-v-clear-all)')

-- vsnip --

opts = { remap=true, expr=true, replace_keycodes=false }
vim.keymap.set({'i','s'}, '<C-J>',   "vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-J>'",   opts)
vim.keymap.set({'i','s'}, '<C-L>',   "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-L>'",   opts)
vim.keymap.set({'i','s'}, '<Tab>',   "vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'",   opts)
vim.keymap.set({'i','s'}, '<S-Tab>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'", opts)

-- ===================== LSP ======================

-- Override/extend the capabilities of Neovim's LSP completion candidates with Cmp's.
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

-- Diagnostics mappings (':h vim.diagnostic')
opts = { remap=false, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Callback for setting buffer local options upon attaching a buffer to a
-- language server (':h lspconfig-setup')
local on_attach = function(_, bufnr)
  -- Buffer local mappings (':h lsp-buf')
  local bufopts = { remap=false, silent=true, buffer=bufnr }
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
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end

-- use nvim-cmp as completion engine
local cmp = require'cmp'

cmp.setup{
  window = {
    completion = cmp.config.window.bordered()
  },
  sources = cmp.config.sources{
    { name = 'nvim_lsp' },
    { name = 'vsnip' }
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  mapping = cmp.mapping.preset.insert{
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-l>'] = cmp.mapping.complete_common_string(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4)
  },
  performance = {
    debounce = 250
  }
}

require'mason'.setup()
require'mason-lspconfig'.setup{
    ensure_installed = {
      'gopls',
      'sumneko_lua'
    }
}

require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true
      }
    }
  },
  flags = {
    debounce_text_changes = 500,
    exit_timeout = 3000
  }
}

require'lspconfig'.sumneko_lua.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- https://github.com/sumneko/lua-language-server/wiki/Settings
    Lua = {
      runtime = {
        version = 'LuaJIT',  -- Neovim embeds LuaJIT
      },
      diagnostics = {
        globals = { 'vim' }  -- recognize globals defined by Neovim
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true)  -- include all Neovim runtime files
      }
    }
  },
  flags = {
    debounce_text_changes = 500,
    exit_timeout = 3000
  }
}

-- ================== Treesitter ==================

require'nvim-treesitter.configs'.setup{
  ensure_installed = {
    'go',
    'yaml',
    'json',
    'lua',
    'vim'
  },
  highlight = {
    enable = true
  }
}

-- ========== Providers and Integrations ==========

-- Neovim's assigned virtualenv for python3 provider (':h python-virtualenv')
vim.g.python3_host_prog = '~/.local/share/nvim/py3venv/bin/python3'

-- ================== Appearance ==================

vim.opt.termguicolors = true  -- enable 24-bit true color
vim.opt.background = 'dark'

vim.g.everforest_enable_italic = true

-- Apply custom highlights on colorscheme change.
-- Must be declared before executing ':colorscheme'.
grpid = vim.api.nvim_create_augroup('custom_highlights_everforest', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = grpid,
  pattern = 'everforest',
  command = -- go
            'hi link @field.go Fg |' ..
            -- file explorer
            'hi NvimTreeVertSplit   guifg=#2f383e |' ..
            'hi NvimTreeNormal      guibg=#282f34 |' ..
            'hi NvimTreeEndOfBuffer guibg=#282f34'
})

vim.cmd.packadd{ 'everforest', bang = true }
vim.cmd.colorscheme('everforest')
