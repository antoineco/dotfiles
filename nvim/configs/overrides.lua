local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "go",
    "c",
    "markdown",
    "markdown_inline",
  },
}

M.mason = {
  ensure_installed = {
    -- lua
    "lua-language-server",
    "stylua",

    -- go
    "gopls",

    -- c/cpp
    "clangd",
    "clang-format",
  },
}

M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    icons = {
      show = {
        git = true,
      },
    },
  },
}

-- Prevent error during the initial Lazy bootstrap:
--   Error detected while processing ~/.config/nvim/init.lua:
--   Failed to load `custom.plugins`
--   ~/.config/nvim/lua/custom/plugins.lua:1: loop or previous error loading module 'custom.configs.overrides'
local cmp_ok, cmp = pcall(require, "cmp")

if cmp_ok then
  M.cmp = {
    mapping = {
      ["<C-y>"] = cmp.mapping.confirm { select = false },
    },
  }
end

return M
