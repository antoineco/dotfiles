-- go_org_imports rearranges Go imports by requesting the "source.organizeImports" code action from gopls.
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
function go_org_imports(wait_ms)
  local clients = vim.lsp.buf_get_clients()
  for _, client in pairs(clients) do
    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = {only = {"source.organizeImports"}}

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
end
