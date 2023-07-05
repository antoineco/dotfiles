local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- lua
  b.formatting.stylua,

  -- shell
  b.diagnostics.shellcheck,
  b.code_actions.shellcheck,

  -- c/cpp
  b.formatting.clang_format,
}

null_ls.setup {
  on_attach = function(_, bufnr)
    require("core.utils").load_mappings("lspconfig", { buffer = bufnr })
  end,

  sources = sources,
}
