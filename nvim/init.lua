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

local colorscheme = "mellifluous"

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

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add Diagnostics to Location List" })
vim.keymap.set("t", "<leader><esc>", "<C-\\><C-n>", { desc = "Exit Terminal Insert mode" })

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
      vim.api.nvim_create_autocmd("ColorSchemePre", {
        group = nvinit_augrp,
        pattern = "everforest",
        callback = function()
          vim.g.everforest_background = vim.o.bg == "dark" and "medium" or "hard"
        end
      })
      vim.g.everforest_enable_italic = true
    end
  },
  {
    "ramojus/mellifluous.nvim",
    lazy = colorscheme ~= "mellifluous",
    priority = 1000,
    opts = {
      mellifluous = {
        color_overrides = {
          dark = {
            bg = function(bg)
              return bg:lightened(2)  -- soft contrast
            end,
            colors = function(colors)
              return {
                fg = colors.fg:darkened(7),
                shades_fg = colors.fg
              }
            end
          },
          light = {
            bg = function(bg)
              return bg:lightened(2)  -- hard contrast
            end
          }
        }
      },
      highlight_overrides = {
        dark = function(highlighter, colors)
          local set_flow_style = function(name)
            highlighter.set(name, {
              bold = true,
              -- compensate for the difference in perceptual contrast due to boldness
              fg = colors.main_keywords:darkened(10)
            })
          end
          set_flow_style "Conditional"
          set_flow_style "Repeat"
        end,
        light = function(highlighter, colors)
          local set_flow_style = function(name)
            highlighter.set(name, {
              bold = true,
              -- compensate for the difference in perceptual contrast due to boldness
              fg = colors.main_keywords:lightened(8)
            })
          end
          set_flow_style "Conditional"
          set_flow_style "Repeat"
        end
      },
      plugins = {
        aerial = false,
        cmp = false,
        indent_blankline = false,
        mason = false,
        neo_tree = { enabled = false },
        neorg = false,
        nvim_notify = false,
        nvim_tree = { enabled = false },
        startify = false,
        telescope = { enabled = false }
      }
    }
  },

  "nvim-tree/nvim-web-devicons",

  -- }}}

  -- Navigation {{{

  {
    "vim-scripts/BufOnly.vim",
    cmd = "Bonly"
  },

  -- }}}

  -- Language Servers {{{

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "◆",
            [vim.diagnostic.severity.WARN] = "▼",
            [vim.diagnostic.severity.INFO] = "■",
            [vim.diagnostic.severity.HINT] = "●"
          }
        }
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = nvinit_augrp,
        callback = function(e)
          -- Mappings {{{

          local lspb = vim.lsp.buf

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = e.buf, desc = desc })
          end

          map("n", "grt", lspb.type_definition, "Goto Type Definition")
          map("n", "grD", lspb.declaration, "Goto Declaration")

          map("n", "<leader>fm", function() lspb.format { async = true } end, "Format")

          -- Extend |CTRL-L-default|
          -- https://github.com/neovim/neovim/blob/v0.11.0/runtime/lua/vim/_defaults.lua#L95-L100
          map("n", "<C-L>", function()
            vim.lsp.buf.clear_references()
            vim.cmd "nohlsearch|diffupdate|normal! <C-L>"
          end, "Clear document highlights")
          map("n", "<leader>dh", lspb.document_highlight, "Request document highlights")

          map("n", "<leader>wa", lspb.add_workspace_folder, "Add Workspace Folder")
          map("n", "<leader>wr", lspb.remove_workspace_folder, "Remove Workspace Folder")
          map("n", "<leader>wl", function() print(vim.inspect(lspb.list_workspace_folders())) end,
            "List Workspace Folders")

          -- }}}

          -- Commands {{{

          vim.api.nvim_buf_create_user_command(e.buf, "LspToggleInlayHints", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = e.buf }, { bufnr = e.buf })
          end, { desc = "Toggle LSP inlay hints" })

          -- }}}
        end
      })

      local lspconfig = require "lspconfig"

      lspconfig.lua_ls.setup {
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
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library"
                }
              }
            })
          end
        end
      }

      lspconfig.bashls.setup {}

      lspconfig.nixd.setup {}
    end
  },

  -- }}}

  -- Completion {{{

  {
    "saghen/blink.cmp",
    build = "nix run .#build-plugin",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {}
  },

  -- }}}

  -- Version Control {{{

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs_staged_enable = false,
      on_attach = function(buffer)
        local gs = require "gitsigns"

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local line = vim.fn.line

        map("n", "]h", function() gs.nav_hunk "next" end, "Goto Next Hunk")
        map("n", "[h", function() gs.nav_hunk "prev" end, "Goto Previous Hunk")

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
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    opts = {
      diagnostic = false,  -- configured globally via vim.diagnostic.config()
      lsp_cfg = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true
            },
            diagnosticsDelay = "1s",
            diagnosticsTrigger = "Edit"
          }
        }
      },
      lsp_keymaps = false,
      lsp_inlay_hints = {
        enable = false
      },
      lsp_on_client_start = function()
        -- gopls doesn't differentiate between types of keywords (import, function, repeat, conditional),
        -- so we fall back to Tree-sitter highlights for these.
        vim.api.nvim_set_hl(0, "@lsp.type.keyword.go", {})
      end
    }
  },

  -- }}}

  -- Rust language {{{

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          code_actions = {
            ui_select_fallback = true
          },
          float_win_config = {
            border = { "", "", "", " " }
          }
        },
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = { ".direnv" }
              }
            }
          },
          on_attach = function(_, bufnr)
            vim.keymap.set({ "n", "x" }, "gra", require "rustaceanvim.commands.code_action_group", {
              buffer = bufnr, desc = "Code Actions"
            })
          end
        }
      }
    end
  },

  -- }}}

  -- Search {{{

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", function() require "fzf-lua".files() end,     desc = "Find Files" },
      { "<leader>ft", function() require "fzf-lua".live_grep() end, desc = "Find Text" },
      { "<leader>fb", function() require "fzf-lua".buffers() end,   desc = "Find Buffers" }
    },
    opts = {}
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
            ["iB"] = { query = "@block.inner", desc = "inner Block from [{ and ]}" },
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
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cmd = "TSContextEnable"
  },

  -- }}}

  -- Testing {{{

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      -- adapters
      {
        "fredrikaverpil/neotest-golang"
      }
    },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = nvinit_augrp,
        pattern = "neotest-output",
        callback = function(e)
          vim.keymap.set("n", "q", function() vim.api.nvim_win_close(0, true) end, {
            buffer = e.buf, desc = "Close Output Window"
          })
        end
      })

      require "neotest".setup {
        adapters = {
          require "rustaceanvim.neotest",
          require "neotest-golang"
        }
      }
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require "neotest".run.run()
        end,
        desc = "Run Nearest Test"
      },
      {
        "<leader>tf",
        function()
          require "neotest".run.run(vim.fn.expand "%")
        end,
        desc = "Run Tests in Current File"
      },
      {
        "<leader>ts",
        function()
          require "neotest".summary.toggle()
        end,
        desc = "Toggle Tests Summary"
      },
      {
        "<leader>to",
        function()
          require "neotest".output.open()
        end,
        desc = "Open Test Output"
      }
    }
  },

  -- }}}

  -- Debugging {{{

  {
    "mfussenegger/nvim-dap",
    cmd = { "DapNew", "DapToggleBreakpoint" },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        opts = {}
      },
      -- adapters
      { "leoluz/nvim-dap-go", opts = {} }
    }
  },

  -- }}}

  -- Miscellaneous {{{

  {
    "brenoprata10/nvim-highlight-colors",
    cmd = "HighlightColors",
    opts = {
      render = "virtual",
      virtual_symbol = "",
      enable_named_colors = false
    }
  }

  -- }}}
}, {
  defaults = {
    lazy = true
  },
  install = {
    colorscheme = { colorscheme }
  },
  rocks = {
    enabled = false
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
    local v = e.data.params.value

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

    local function process_message(msg)
      -- These messages tend to exceed v:echospace and cause hit-enter prompts.
      if (c and c.name) == "rust-analyzer" and v.title == "Roots Scanned" then
        local prefix, relpath = msg:match "^(.+: )/.+/lib/rustlib/src/rust/(.*)$"
        if prefix then
          return prefix .. "<sysroot-rustsrc>/" .. relpath
        end
        prefix, relpath = msg:match "^(.+: )/.+%.cargo/registry/src/index.crates.io%-%w+/(.*)$"
        return prefix and prefix .. "<cargo-crates>/" .. relpath or msg
      end
      return msg
    end

    local content = icon
    content = c and string.format("%s %s", content, c.name) or content
    content = v.title and string.format("%s [%s]", content, v.title) or content
    content = v.message and string.format("%s %s", content, process_message(v.message)) or content
    content = v.percentage and string.format("%s (%s%%)", content, v.percentage) or content

    vim.notify(content, vim.log.levels.INFO)
  end
})

vim.cmd.colorscheme(colorscheme)

-- }}}
