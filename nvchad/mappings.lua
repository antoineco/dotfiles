---@type MappingsTable
local M = {}

M.lspconfig = {
  n = {
    ["gI"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },
  },
}

M.gitsigns = {
  n = {
    ["<leader>sh"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage hunk",
    },

    ["<leader>sb"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage buffer",
    },
  },
}

return M
