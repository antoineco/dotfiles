local M = {}

-- Rearrange Go imports by requesting the "source.organizeImports" code action from gopls.
-- Adapted from https://go.googlesource.com/tools/+/refs/tags/v0.8.0/gopls/doc/vim.md#imports
function M.org_imports(wait_ms)
  vim.lsp.buf.code_action({
    context = { only = { 'source.organizeImports' } },
    apply = true
  })
end

return M
