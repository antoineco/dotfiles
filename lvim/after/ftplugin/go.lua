local opts = vim.tbl_extend('force', lvim.builtin.which_key.opts, { buffer = vim.api.nvim_get_current_buf() })

local mappings = {
  l = {
    ['oi'] = { "<cmd>lua require 'user.go'.org_imports()<CR>", 'Organize Imports' },
  },
  G = {
    name = 'Go',
    b = { '<Plug>(go-build)', 'Build package' },
    t = {
      name = 'Tests',
      p = { '<Plug>(go-test)', 'Package' },
      f = { '<Plug>(go-test)', 'Function' },
      c = { '<Plug>(go-test-compile)', 'Compile' },
    }
  }
}

require 'which-key'.register(mappings, opts)
