return {
  {
    'rose-pine/neovim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  },
  { import = 'specter.plugins.ui' },
  { import = 'specter.plugins.misc' },
  { import = 'specter.plugins.treesitter' },
  { import = 'specter.plugins.gitsigns' },
  { import = 'specter.plugins.telescope' },
  { import = 'specter.plugins.lsp' },
  { import = 'specter.plugins.conform' },
  { import = 'specter.plugins.cmp' },
  { import = 'specter.plugins.guess-indent' },
}