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

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-Space>",
      node_incremental = "<C-Space>",
      node_decremental = "<BS>",
    },
  },

  textobjects = {
    select = {
      enable = true,
      -- stylua: ignore
      keymaps = {
        ["af"] = { query = "@function.outer",  desc = "a function (with keyword, name and params)" },
        ["if"] = { query = "@function.inner",  desc = "inner function" },
        ["ac"] = { query = "@class.outer",     desc = "a class or type (with keyword and name)" },
        ["ic"] = { query = "@class.inner",     desc = "inner class or type" },
        ["aa"] = { query = "@parameter.outer", desc = "a parameter" },
        ["ia"] = { query = "@parameter.outer", desc = "inner parameter" },
        ["aB"] = { query = "@block.outer",     desc = "a Block from [{ to ]} (with brackets)" },
        ["iB"] = { query = "@parameter.outer", desc = "inner Block from [{ and ]}" },
        ["aS"] = { query = "@scope",           desc = "language-specific scope" },
        ["iS"] = { query = "@scope",           desc = "language-specific scope" },
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua
    "lua-language-server",
    "stylua",

    -- go
    "gopls",

    -- shell
    "shellcheck",

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
