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
vim.opt.mouse = ''         -- disable mouse support

vim.opt.completeopt = { 'menu',       -- show completions in popup menu
                        'menuone',    -- ... even if there is only one match
                        'noselect' }  -- do not auto-select completion candidate

vim.opt.wildmode = { 'list:longest',  -- 1st Tab completes till longest common string,
                     'list:full' }    -- 2nd Tab opens wildmenu

-- ==================== Plugins ===================

-- WebDevicons --

require'nvim-web-devicons'.setup{
  default = true
}

-- Tree --

require'nvim-tree'.setup()

local opts = { remap=false, silent=true }
vim.keymap.set('n', '<Leader>n', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<Leader>f', ':NvimTreeFindFile<CR>', opts)

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
local grpid = vim.api.nvim_create_augroup('lightline_reload_colorscheme', {})
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

-- Diagnostics mappings (':h vim.diagnostic')
opts = { remap=false, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Callback for setting buffer local options upon attaching a buffer to a
-- language server (':h lspconfig-setup')
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o> (':h compl-omni')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
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
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm{ select = true },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4)
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
        special = {
          require = 'require',  -- prevent "undefined global required"
        }
      },
      diagnostics = {
        globals = { 'vim', 'print' }  -- recognize globals defined by Neovim
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true)  -- include all Neovim runtime files
      }
    }
  }
}

-- ================== Treesitter ==================

require'nvim-treesitter.configs'.setup{
  ensure_installed = {
    'go',
    'yaml',
    'lua',
    'vim'
  },
  sync_install = true,  -- display messages when parsers are being automatically installed
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

vim.cmd'packadd! everforest'
vim.cmd'colorscheme everforest'
