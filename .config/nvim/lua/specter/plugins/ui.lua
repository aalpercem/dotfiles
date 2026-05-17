return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- ------------------------------------------------------------------------
      -- xcodebuild.nvim status helper for lualine
      -- ------------------------------------------------------------------------
      -- Displays the currently selected simulator / device name and OS version.
      -- Automatically updates whenever you change device via :XcodebuildSelectDevice.
      local function xcodebuild_device()
        if vim.g.xcodebuild_platform == 'macOS' then
          return ' macOS'
        end

        local device_icon = ''
        if vim.g.xcodebuild_platform and vim.g.xcodebuild_platform:match 'watch' then
          device_icon = '􀟤'
        elseif vim.g.xcodebuild_platform and vim.g.xcodebuild_platform:match 'tv' then
          device_icon = '􀡴 '
        elseif vim.g.xcodebuild_platform and vim.g.xcodebuild_platform:match 'vision' then
          device_icon = '􁎖 '
        end

        if vim.g.xcodebuild_os then
          return device_icon .. ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'
        end

        return device_icon .. ' ' .. (vim.g.xcodebuild_device_name or 'No Device')
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'rose-pine',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = {
            -- Last build / test status (e.g. "Build Succeeded [12s]")
            { "' ' .. vim.g.xcodebuild_last_status", color = { fg = 'Gray' } },
            -- Selected test plan
            { "'󰙨 ' .. (vim.g.xcodebuild_test_plan or '')", color = { fg = '#a6e3a1', bg = '#161622' } },
            -- Selected device / simulator
            { xcodebuild_device, color = { fg = '#f9e2af', bg = '#161622' } },
            -- File encoding and format (original lualine defaults)
            'encoding',
            'fileformat',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>x', group = 'Xcodebuild' },
        { '<leader>d', group = 'Debug / DAP' },
      },
    },
  },
}