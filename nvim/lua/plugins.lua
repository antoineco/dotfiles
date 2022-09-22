local ensure_packer = function()
  local install_path = vim.fn.stdpath'data' .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system{'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim.git', install_path}
    vim.cmd'packadd packer.nvim'
    return true
  end
  return false
end

local packer_bootstrapped = ensure_packer()

require'packer'.init{
  compile_path = vim.fn.stdpath'data' .. '/site/plugin/packer_compiled.lua'
}

return require'packer'.startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Lang / LSP
  use 'neovim/nvim-lspconfig'
  use { 'hrsh7th/nvim-cmp', branch = 'main',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
      { 'hrsh7th/cmp-vsnip', branch = 'main' }
    }
  }
  use { 'hrsh7th/vim-vsnip', requires = 'hrsh7th/vim-vsnip-integ' }
  use { 'nvim-treesitter/nvim-treesitter', run = function()
    -- wbthomason/packer.nvim#1050
    if vim.fn.exists(':TSUpdate') == 2 then vim.cmd.TSUpdate() end
  end }
  use 'nvim-treesitter/playground'

  -- VCS
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- Navigation
  use 'kyazdani42/nvim-tree.lua'
  use 'qxxxb/vim-searchhi'
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }

  -- UI
  use { 'itchyny/lightline.vim', requires = 'kyazdani42/nvim-web-devicons' }

  -- Syntax / Language helpers
  use 'fatih/vim-go'

  -- Themes / Color schemes
  use { 'sainnhe/everforest', opt = true }
  use { 'shaunsingh/nord.nvim', opt = true }

  -- Sync after initial bootstrap
  if packer_bootstrapped then
    require'packer'.sync()
  end
end)
