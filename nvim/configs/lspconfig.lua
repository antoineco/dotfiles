local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "clangd" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
  end,

  capabilities = capabilities,

  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}
