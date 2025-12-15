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

-- }}}

-- Appearance {{{

vim.o.termguicolors = true  -- enable 24-bit true color
vim.o.guifont = "MonoLisa"  -- for Neovide

-- }}}

-- }}}

-- [[ Plugins ]] {{{

vim.pack.add {
  -- User Interface
  "https://github.com/ramojus/mellifluous.nvim.git",
  "https://github.com/nvim-tree/nvim-web-devicons.git",
  -- Navigation
  "https://github.com/vim-scripts/BufOnly.vim.git",
  -- Language Servers
  "https://github.com/neovim/nvim-lspconfig.git",
  -- Completion
  "https://github.com/rafamadriz/friendly-snippets.git",
  -- Version Control
  "https://github.com/lewis6991/gitsigns.nvim.git",
  -- Go language
  "https://github.com/ray-x/go.nvim.git",
  "https://github.com/ray-x/guihua.lua.git",
  -- Rust language
  "https://github.com/mrcjkb/rustaceanvim.git",
  -- Search
  "https://github.com/ibhagwan/fzf-lua.git",
  -- Tree-sitter
  "https://github.com/nvim-treesitter/nvim-treesitter-context.git",
  -- Testing
  "https://github.com/nvim-neotest/neotest.git",
  "https://github.com/nvim-neotest/nvim-nio.git",
  "https://github.com/antoinemadec/FixCursorHold.nvim.git",
  "https://github.com/fredrikaverpil/neotest-golang.git",
  "https://github.com/nvim-lua/plenary.nvim.git",
  -- Debugging
  "https://github.com/mfussenegger/nvim-dap.git",
  "https://github.com/rcarriga/nvim-dap-ui.git",
  "https://github.com/leoluz/nvim-dap-go.git",
  -- Miscellaneous
  "https://github.com/brenoprata10/nvim-highlight-colors.git"
}

require "mellifluous".setup {
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
    lazy = false,
    mason = false,
    neo_tree = { enabled = false },
    neorg = false,
    nvim_notify = false,
    nvim_tree = { enabled = false },
    startify = false,
    telescope = { enabled = false }
  }
}

do
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

  local luals_markers = vim.lsp.config["lua_ls"].root_markers or {}
  local idx_git = vim.iter(luals_markers):enumerate():find(function(_, f) return f == ".git" end) or (#luals_markers + 1)
  table.insert(luals_markers, idx_git, ".editorconfig")
  vim.lsp.config("lua_ls", {
    settings = {
      -- https://github.com/LuaLS/lua-language-server/blob/3.15.0/doc/en-us/config.md
      Lua = {
        completion = {
          callSnippet = "Replace"  -- snippet support on completion
        }
      }
    },
    root_markers = luals_markers,
    on_init = function(client)
      local ws = client.workspace_folders and client.workspace_folders[1].name or nil
      local is_neovim_workspace = ws == vim.uv.fs_realpath(vim.fn.stdpath "config")
      if is_neovim_workspace and not (vim.uv.fs_stat(ws .. "/.luarc.json") or vim.uv.fs_stat(ws .. "/.luarc.jsonc")) then
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
            -- Find Lua modules the same way Neovim does (see `:h lua-module-load`)
            path = {
              "lua/?.lua",
              "lua/?/init.lua"
            }
          },
          workspace = {
            checkThirdParty = false,  -- remove prompts to configure work environment
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
              "${3rd}/busted/library"
            }
          }
        })
      end
    end
  })
  vim.lsp.enable "lua_ls"

  vim.lsp.enable "bashls"

  vim.lsp.enable "nixd"
end

require "blink.cmp".setup {}

require "gitsigns".setup {
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

do
  -- The setup will fail outside of Go projects if we don't mark 'gopls' as
  -- installed, because the 'go.lsp' module then attempts to install 'gopls'
  -- using a non-existent 'go' executable.
  require "go.utils".installed_tools["gopls"] = true
  require "go".setup {
    textobjects = false,
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
    }
  }
end

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
      vim.keymap.set({ "n", "x" }, "gra", function() vim.cmd.RustLsp "codeAction" end, {
        buffer = bufnr, desc = "Code Actions"
      })
    end
  }
}

do
  vim.keymap.set("n", "<leader>fz", function() require "fzf-lua.cmd".run_command() end, { desc = "Fzf Actions" })
  vim.keymap.set("n", "<leader>ff", function() require "fzf-lua".files() end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>ft", function() require "fzf-lua".live_grep() end, { desc = "Find Text" })
  vim.keymap.set("n", "<leader>fb", function() require "fzf-lua".buffers() end, { desc = "Find Buffers" })
end

do
  local function autostart(ft)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { ft },
      callback = function() vim.treesitter.start() end
    })
  end
  autostart "go"
  autostart "rust"
end
do
  local function map(mode, l, query, desc, r)
    vim.keymap.set(mode, l, function() r(query, "textobjects") end, { desc = desc })
  end

  local function map_select(l, query, desc)
    map({ "x", "o" }, l, query, desc, require "nvim-treesitter-textobjects.select".select_textobject)
  end

  local function map_move(l, query, desc, r)
    local query_desc = {
      ["@function.outer"] = "function",
      ["@class.outer"] = "class or type",
      ["@parameter.outer"] = "parameter"
    }
    map({ "n", "x", "o" }, l, query, table.concat({ desc, query_desc[query] }, " "), r)
  end
  local function map_move_next_start(l, query)
    map_move(l, query, "start of next", require "nvim-treesitter-textobjects.move".goto_next_start)
  end
  local function map_move_next_end(l, query)
    map_move(l, query, "end of next", require "nvim-treesitter-textobjects.move".goto_next_end)
  end
  local function map_move_previous_start(l, query)
    map_move(l, query, "start of previous", require "nvim-treesitter-textobjects.move".goto_previous_start)
  end
  local function map_move_previous_end(l, query)
    map_move(l, query, "end of previous", require "nvim-treesitter-textobjects.move".goto_previous_end)
  end

  map_select("af", "@function.outer", "a function (with keyword, name and params)")
  map_select("if", "@function.inner", "inner function")
  map_select("ac", "@class.outer", "a class or type (with keyword and name)")
  map_select("ic", "@class.inner", "inner class or type")
  map_select("aa", "@parameter.outer", "a parameter")
  map_select("ia", "@parameter.inner", "inner parameter")
  map_select("aB", "@block.outer", "a Block from [{ to ]} (with brackets)")
  map_select("iB", "@block.inner", "inner Block from [{ and ]}")
  map_select("aS", "@scope", "language-specific scope")
  map_select("iS", "@scope", "language-specific scope")

  map_move_next_start("]m", "@function.outer")
  map_move_next_start("]]", "@class.outer")
  map_move_next_start("]a", "@parameter.outer")
  map_move_next_end("]M", "@function.outer")
  map_move_next_end("][", "@class.outer")
  map_move_next_end("]A", "@parameter.outer")
  map_move_previous_start("[m", "@function.outer")
  map_move_previous_start("[[", "@class.outer")
  map_move_previous_start("[a", "@parameter.outer")
  map_move_previous_end("[M", "@function.outer")
  map_move_previous_end("[]", "@class.outer")
  map_move_previous_end("[A", "@parameter.outer")
end

do
  vim.api.nvim_create_autocmd("FileType", {
    group = nvinit_augrp,
    pattern = "neotest-output",
    callback = function(e)
      vim.keymap.set("n", "q", function() vim.api.nvim_win_close(0, true) end, {
        buffer = e.buf, desc = "Close Output Window"
      })
    end
  })

  vim.keymap.set("n", "<leader>tt", function() require "neotest".run.run() end, {
    desc = "Run Nearest Test"
  })
  vim.keymap.set("n", "<leader>tf", function() require "neotest".run.run(vim.fn.expand "%") end, {
    desc = "Run Tests in Current File"
  })
  vim.keymap.set("n", "<leader>ts", function() require "neotest".summary.toggle() end, {
    desc = "Toggle Tests Summary"
  })
  vim.keymap.set("n", "<leader>to", function() require "neotest".output.open() end, {
    desc = "Open Test Output"
  })
  vim.keymap.set("n", "<leader>tp", function() require "neotest".output_panel.toggle() end, {
    desc = "Toggle Tests Output Panel"
  })

  require "neotest".setup {
    adapters = {
      require "rustaceanvim.neotest",
      require "neotest-golang" { runner = "gotestsum" }
    }
  }
end

do
  local hlc = require "nvim-highlight-colors"
  hlc.setup {
    render = "virtual",
    virtual_symbol = "",
    enable_named_colors = false
  }
  hlc.turnOff()
end

do
  vim.keymap.set("n", "<F5>", function() require "dap".step_over() end, { desc = "Step Over" })
  vim.keymap.set("n", "<F6>", function() require "dap".step_into() end, { desc = "Step Into" })
  vim.keymap.set("n", "<F4>", function() require "dap".step_out() end, { desc = "Step Out" })
  vim.keymap.set("n", "<F8>", function() require "dap".step_back() end, { desc = "Step Back" })

  do
    vim.keymap.set("n", "<leader>du", function() require "dapui".toggle() end, { desc = "Toggle DAP UI" })
    require "dapui".setup {}
  end

  do
    require "dap-go".setup {}

    local dap = require "dap"
    local dap_go_adapter = dap.adapters.go
    dap.adapters.go = function(callback, client_config)
      if client_config.mode == "remote" and client_config.host and client_config.port then
        callback {
          type = "server",
          host = client_config.host,
          port = client_config.port
        }
        return
      end
      dap_go_adapter(callback, client_config)
    end
  end
end

-- [[ Miscellaneous ]] {{{

-- Status line - requires some of the plugins installed above
vim.o.statusline = "%!v:lua.St.draw()"  -- see `:h v:lua-call`

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
