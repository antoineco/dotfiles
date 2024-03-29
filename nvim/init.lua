-- [[ Neovim general settings ]] {{{

local nvinit_augrp = vim.api.nvim_create_augroup("user_nvim_init", {})

-- UI {{{

vim.o.number = true          -- display line numbers
vim.o.relativenumber = true  -- line numbers relative to cursor
vim.o.scrolloff = 8          -- number of lines to show above/below cursor
vim.o.laststatus = 3         -- always show status line, only active window
vim.o.showmode = false       -- hide mode in cmd line, redundant with statusline
vim.o.colorcolumn = "+1"     -- highlight textwidth column
vim.o.clipboard = ""         -- no implicit interaction with clipboard register

-- Toggle relative line numbers on focus change
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = nvinit_augrp,
  pattern = "*",
  callback = function()
    if vim.o.nu and vim.fn.mode() ~= "i" then
      vim.o.rnu = true
    end
  end
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = nvinit_augrp,
  pattern = "*",
  callback = function()
    if vim.o.nu then
      vim.o.rnu = false
    end
  end
})

local colorscheme = "everforest"

St = require "user.statusline"

-- Set statusline highlights
vim.api.nvim_create_autocmd("ColorScheme", {
  group = nvinit_augrp,
  pattern = "*",
  callback = St.set_highlights
})

-- }}}

-- Behaviour {{{

vim.g.mapleader = " "    -- more accessible leader key
vim.o.splitbelow = true  -- open horizontal split below
vim.o.splitright = true  -- open vertical split to the right
vim.o.smartcase = true   -- make search case sensitive when pattern contains uppercase chars
vim.o.ignorecase = true  -- required by smartcase

vim.opt.completeopt = {
  "menu",     -- show completions in popup menu
  "menuone",  -- ... even if there is only one match
  "noselect"  -- do not auto-select completion candidate
}

vim.opt.wildmode = {
  "longest",  -- 1st Tab completes till longest common string,
  "full"      -- 2nd Tab opens wildmenu
}

-- }}}

-- Mappings {{{

local function map(mode, l, r, desc)
  vim.keymap.set(mode, l, r, { desc = desc })
end

map("n", "]d", vim.diagnostic.goto_next, "Goto Next Diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Goto Previous Diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Show Line Diagnostic")
map("n", "<leader>q", vim.diagnostic.setloclist, "Add Diagnostics to Location List")

-- }}}

-- Appearance {{{

vim.o.termguicolors = true  -- enable 24-bit true color

-- }}}

-- }}}

-- [[ Plugins ]] {{{

-- Bootstrap {{{

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

-- }}}

-- Setup {{{

require "lazy".setup({
  -- Shared Plugin Libraries {{{

  "nvim-lua/plenary.nvim",

  -- }}}

  -- User Interface {{{

  {
    "sainnhe/everforest",
    lazy = colorscheme ~= "everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme(colorscheme)
    end
  },

  "nvim-tree/nvim-web-devicons",

  -- }}}

  -- Language Servers {{{

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "mason.nvim",  -- mason/bin must be present in PATH for tools to be run
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require "cmp_nvim_lsp".default_capabilities()
      )

      local icons = {
        Error = " ",
        Warn  = " ",
        Hint  = " ",
        Info  = " "
      }

      for name, icon in pairs(icons) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = nvinit_augrp,
        callback = function(e)
          local lspb = vim.lsp.buf

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = e.buf, desc = desc })
          end

          map("n", "gd", lspb.definition, "Goto Definition")
          map("n", "gD", lspb.declaration, "Goto Declaration")
          map("n", "gi", lspb.implementation, "Goto Implementation")
          map("n", "gr", lspb.references, "Goto references")
          map("n", "<leader>D", lspb.type_definition, "Goto Type Definition")

          map("n", "<C-k>", lspb.signature_help, "Display Symbol Signature")

          map("n", "<leader>rn", lspb.rename, "Rename")
          map("n", "<leader>fm", function() lspb.format { async = true } end, "Format")
          map({ "n", "v" }, "<leader>ca", lspb.code_action, "Code Actions")

          map("n", "<leader>wa", lspb.add_workspace_folder, "Add Workspace Folder")
          map("n", "<leader>wr", lspb.remove_workspace_folder, "Remove Workspace Folder")
          map("n", "<leader>wl", function() print(vim.inspect(lspb.list_workspace_folders())) end,
            "List Workspace Folders")
        end
      })

      require "lspconfig".lua_ls.setup {
        capabilities = capabilities,
        settings = {
          -- https://github.com/LuaLS/lua-language-server/blob/3.6.24/doc/en-us/config.md
          Lua = {
            workspace = {
              checkThirdParty = false  -- remove prompts to configure work environment
            },
            completion = {
              callSnippet = "Replace"  -- snippet support on completion
            }
          }
        },
        on_init = function(client)
          local ws = client.workspace_folders[1].name
          if not vim.uv.fs_stat(ws .. "/.luarc.json") and not vim.uv.fs_stat(ws .. "/.luarc.jsonc") then
            -- Assume Neovim workspace
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT"
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            })
          end
        end
      }

      require "lspconfig".gopls.setup {
        capabilities = capabilities,
        settings = {
          -- https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
          gopls = {
            usePlaceholders = true,
            gofumpt = true,
            analyses = {
              unusedparams = true
            }
          }
        }
      }

      require "lspconfig".rust_analyzer.setup {
        capabilities = capabilities
      }
    end
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "mason.nvim",  -- mason/bin must be present in PATH for tools to be run
    opts = function()
      local b = require "null-ls".builtins
      return {
        sources = {
          -- shell
          b.diagnostics.shellcheck,
          b.code_actions.shellcheck
        }
      }
    end
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {}
  },

  -- }}}

  -- Completion {{{

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- snippets
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        config = function(_, opts)
          require "luasnip.config".setup(opts)
          require "luasnip.loaders.from_vscode".lazy_load()
        end
      },
      -- completion sources
      {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip"
      }
    },
    opts = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      local icons = {
        Array = " ",
        Boolean = " ",
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Namespace = " ",
        Null = " ",
        Number = " ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " "
      }

      return {
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-l>"] = cmp.mapping.complete_common_string(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Super-Tab; complete or expand snippet
          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings/0c933f3c#luasnip
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        },
        snippet = {
          expand = function(args)
            require "luasnip".lsp_expand(args.body)
          end
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" }
        },
        formatting = {
          format = function(_, item)
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end
        }
      }
    end
  },

  -- }}}

  -- Version Control {{{

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buffer)
        local gs = require "gitsigns"

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local line = vim.fn.line

        map("n", "]h", gs.next_hunk, "Goto Next Hunk")
        map("n", "[h", gs.prev_hunk, "Goto Previous Hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("v", "<leader>hs", function() gs.stage_hunk { line ".", line "v" } end, "Stage Hunk")
        map("v", "<leader>hr", function() gs.reset_hunk { line ".", line "v" } end, "Reset Hunk")

        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")

        map("n", "<leader>hb", function() gs.blame_line { full = true } end, "Blame Line")

        map("n", "<leader>hd", gs.diffthis, "Diff Against Index")
        map("n", "<leader>hD", function() gs.diffthis "~" end, "Diff Against HEAD")

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
      end
    }
  },

  -- }}}

  -- Go language {{{

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
    end
  },

  -- }}}

  -- Search {{{

  {
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-treesitter",
    keys = {
      { "<leader>ff", function() require "telescope.builtin".find_files() end, desc = "Find Files" },
      { "<leader>ft", function() require "telescope.builtin".live_grep() end,  desc = "Find Text" },
      { "<leader>fb", function() require "telescope.builtin".buffers() end,    desc = "Find Buffers" }
    }
  },

  -- }}}

  -- Tree-sitter {{{
  -- Language-aware syntax and text objects

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = "TSUpdateSync",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      ensure_installed = { "go", "rust" },

      highlight = {
        enable = true
      },

      indent = {
        enable = true
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          node_decremental = "<BS>"
        }
      },

      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "a function (with keyword, name and params)" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer", desc = "a class or type (with keyword and name)" },
            ["ic"] = { query = "@class.inner", desc = "inner class or type" },
            ["aa"] = { query = "@parameter.outer", desc = "a parameter" },
            ["ia"] = { query = "@parameter.outer", desc = "inner parameter" },
            ["aB"] = { query = "@block.outer", desc = "a Block from [{ to ]} (with brackets)" },
            ["iB"] = { query = "@parameter.outer", desc = "inner Block from [{ and ]}" },
            ["aS"] = { query = "@scope", desc = "language-specific scope" },
            ["iS"] = { query = "@scope", desc = "language-specific scope" }
          }
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]a"] = "@parameter.outer"
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
            ["]A"] = "@parameter.outer"
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[a"] = "@parameter.outer"
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[A"] = "@parameter.outer"
          }
        }
      }
    },
    config = function(_, opts)
      require "nvim-treesitter.configs".setup(opts)
    end
  }

  -- }}}
}, {
  defaults = {
    lazy = true
  },
  install = {
    colorscheme = { colorscheme }
  }
})

-- }}}

-- }}}

-- [[ Miscellaneous ]] {{{

-- Status line - requires some of the plugins installed above
vim.o.statusline = "%!v:lua.St.draw()"  -- ref. ":h v:lua-call"

-- LSP progress messages (Neovim 0.10+)
vim.api.nvim_create_autocmd("LspProgress", {
  group = nvinit_augrp,
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
  end
})

-- }}}
