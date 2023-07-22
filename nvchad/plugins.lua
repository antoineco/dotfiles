local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
  },

  {
    "fatih/vim-go",
    ft = { "go", "gomod", "gosum", "gowork", "gohtmltmpl", "asm" },
    config = function()
      -- features already handled by Neovim's LSP integration
      vim.g.go_gopls_enabled = false
      vim.g.go_fmt_autosave = false
      vim.g.go_mod_fmt_autosave = false
      vim.g.go_imports_autosave = false
      vim.g.go_code_completion_enabled = false
      vim.g.go_doc_keywordprg_enabled = false
      -- features already handled by Tree-sitter
      vim.g.go_textobj_enabled = false
    end,
  },
}

return plugins
