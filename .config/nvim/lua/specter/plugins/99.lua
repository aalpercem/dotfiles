return {
  {
    'ThePrimeagen/99',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'saghen/blink.compat', version = '2.*' },
    },
    config = function()
      local _99 = require '99'

      _99.setup {
        model = 'opencode/deepseek-v4-flash-free',
        tmp_dir = './tmp',
        completion = {
          source = 'blink',
          files = {
            exclude = { '.env', '.env.*', 'node_modules', '.git', 'build', '.build' },
          },
        },
        md_files = { 'AGENT.md' },
      }

      vim.keymap.set('v', '<leader>9v', function()
        _99.visual()
      end, { desc = '99 [V]isual replace' })

      vim.keymap.set('n', '<leader>9x', function()
        _99.stop_all_requests()
      end, { desc = '99 stop all requests' })

      vim.keymap.set('n', '<leader>9s', function()
        _99.search()
      end, { desc = '99 [S]earch project' })

      vim.keymap.set('n', '<leader>9m', function()
        require('99.extensions.telescope').select_model()
      end, { desc = '99 select [M]odel' })

      vim.keymap.set('n', '<leader>9p', function()
        require('99.extensions.telescope').select_provider()
      end, { desc = '99 select [P]rovider' })
    end,
  },
}
