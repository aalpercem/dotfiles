return {
  'S1M0N38/love2d.nvim',
  version = '3.*',
  opts = { output = false },
  keys = {
    { '<leader>v',  '',                     desc = '+LÖVE' },
    { '<leader>vr', '<cmd>Love run<cr>',    desc = '[L]ove: [R]un' },
    { '<leader>vw', '<cmd>Love watch<cr>',  desc = '[L]ove: [W]atch & auto-restart' },
    { '<leader>vs', '<cmd>Love stop<cr>',   desc = '[L]ove: [S]top' },
    { '<leader>vo', '<cmd>Love output<cr>', desc = '[L]ove: [O]utput panel' },
    { '<leader>vi', '<cmd>Love info<cr>',   desc = '[L]ove: [I]nfo' },
  },
}
