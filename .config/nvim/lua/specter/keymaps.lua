vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ============================================================================
-- xcodebuild.nvim — iOS / macOS build, run, test, and debug keymaps
-- ============================================================================
-- All commands start with <leader>x to avoid conflicts with existing mappings.
-- Run :XcodebuildPicker (<leader>X) if you forget a mapping; it shows a
-- searchable menu of every action.
--
-- BUILD & RUN
--   <leader>xb  — Build the project (compile only, do not launch)
--   <leader>xB  — Build For Testing (produces testable artifacts)
--   <leader>xr  — Build & Run on the selected simulator / physical device
--
-- TESTS
--   <leader>xt  — Run all tests for the selected scheme / test plan
--   <leader>xT  — Run tests for the class under the cursor
--   <leader>x.  — Repeat the last test run (handy when fixing failures)
--   v + <leader>xt — Run only the visually selected tests
--
-- DEBUGGING (requires nvim-dap, see dap.lua)
--   <leader>dd  — Build project & start debugging (sets breakpoints, lldb)
--   <leader>dr  — Debug without building (attach to already-running app)
--   <leader>dt  — Debug tests (stops at breakpoints inside test code)
--   <leader>dT  — Debug current test class
--   <leader>db  — Toggle breakpoint on current line
--   <leader>dB  — Toggle message breakpoint (stops on NSLog / print)
--   <leader>dx  — Terminate debugger session and close dap-ui panels
--
-- UI & EXPLORERS
--   <leader>X   — Open XcodebuildPicker (floating menu with ALL actions)
--   <leader>xf  — Open Project Manager (add files, targets, build phases)
--   <leader>xe  — Toggle Test Explorer side panel
--   <leader>xl  — Toggle build / test logs panel
--   <leader>xc  — Toggle code coverage marks on source lines
--   <leader>xC  — Show code coverage report floating window
--   <leader>xp  — Generate SwiftUI / UIKit preview (requires snacks.nvim)
--   <leader>x<CR> — Toggle preview window visibility
--   <leader>xs  — Show failing snapshot tests (swift-snapshot-testing)
--
-- DEVICE & PROJECT
--   <leader>xd  — Select simulator or physical device to run on
--   <leader>xq  — Show QuickFix list with build / test errors
--   <leader>xx  — Quick-fix current line (auto-import, etc.)
--   <leader>xa  — Show code actions for current cursor position
--
-- FILE TREE
--   <leader>e   — Toggle nvim-tree file explorer
-- ============================================================================

-- Picker & project manager
vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Xcodebuild: Show all actions' })
vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Xcodebuild: Project Manager' })

-- Build & run
vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Xcodebuild: Build' })
vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Xcodebuild: Build For Testing' })
vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Xcodebuild: Build & Run' })

-- Tests
vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Xcodebuild: Run Tests' })
vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Xcodebuild: Run Test Class' })
vim.keymap.set('n', '<leader>x.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Xcodebuild: Repeat Last Tests' })
vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Xcodebuild: Run Selected Tests' })

-- UI toggles
vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Xcodebuild: Toggle Test Explorer' })
vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Xcodebuild: Toggle Logs' })
vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Xcodebuild: Toggle Coverage' })
vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Xcodebuild: Coverage Report' })
vim.keymap.set('n', '<leader>xp', '<cmd>XcodebuildPreviewGenerateAndShow<cr>', { desc = 'Xcodebuild: Generate Preview' })
vim.keymap.set('n', '<leader>x<cr>', '<cmd>XcodebuildPreviewToggle<cr>', { desc = 'Xcodebuild: Toggle Preview' })
vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Xcodebuild: Failing Snapshots' })

-- Device & quickfix
vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Xcodebuild: Select Device' })
vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Xcodebuild: QuickFix List' })
vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Xcodebuild: Quickfix Line' })
vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Xcodebuild: Code Actions' })

-- Debugging (nvim-dap + xcodebuild.nvim integration)
-- These are defined in dap.lua but repeated here for discoverability.
vim.keymap.set('n', '<leader>dd', function()
  require('xcodebuild.integrations.dap').build_and_debug()
end, { desc = 'DAP: Build & Debug' })
vim.keymap.set('n', '<leader>dr', function()
  require('xcodebuild.integrations.dap').debug_without_build()
end, { desc = 'DAP: Debug Without Build' })
vim.keymap.set('n', '<leader>dt', function()
  require('xcodebuild.integrations.dap').debug_tests()
end, { desc = 'DAP: Debug Tests' })
vim.keymap.set('n', '<leader>dT', function()
  require('xcodebuild.integrations.dap').debug_class_tests()
end, { desc = 'DAP: Debug Class Tests' })
vim.keymap.set('n', '<leader>db', function()
  require('xcodebuild.integrations.dap').toggle_breakpoint()
end, { desc = 'DAP: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  require('xcodebuild.integrations.dap').toggle_message_breakpoint()
end, { desc = 'DAP: Toggle Message Breakpoint' })
vim.keymap.set('n', '<leader>dx', function()
  require('xcodebuild.integrations.dap').terminate_session()
end, { desc = 'DAP: Terminate Session' })

-- File tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle file tree' })