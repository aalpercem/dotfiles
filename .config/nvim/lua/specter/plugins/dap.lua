-- ============================================================================
-- nvim-dap + nvim-dap-ui — Debugger integration for iOS / macOS apps
-- ============================================================================
-- WHAT IT DOES:
--   Provides a full debugging experience inside Neovim: breakpoints, step over,
--   step into, variable inspection, call stack, and app console logs.
--   xcodebuild.nvim handles the heavy lifting of launching the app on a simulator
--   or physical device and attaching the LLDB debugger automatically.
--
-- DEPENDENCIES:
--   • Xcode 16+ — ships with the native lldb-dap adapter (no extra install needed)
--   • xcodebuild.nvim — must be installed before this plugin loads (see xcodebuild.lua)
--
-- KEYMAPS (defined in keymaps.lua, referenced here for clarity):
--   <leader>dd  — Build project & start debugging
--   <leader>dr  — Debug without building (attach to already-running app)
--   <leader>dt  — Debug tests
--   <leader>dT  — Debug current test class
--   <leader>b   — Toggle breakpoint on current line
--   <leader>B   — Toggle message breakpoint (stops on NSLog / os_log)
--   <leader>dx  — Terminate debugger session
--
-- UI PANELS (nvim-dap-ui opens automatically when debugging starts):
--   • Scopes      — local variables, registers, globals
--   • Breakpoints — list of all breakpoints
--   • Stacks      — call stack with frame selection
--   • Console     — LLDB REPL + app NSLog / print() output
--   • Watches     — expression evaluation
--
-- NOTE:
--   On first use, macOS may prompt you to allow "lldb-rpc-server" network access.
--   Approve it or debugging will silently fail.
-- ============================================================================

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- xcodebuild.nvim provides the DAP configuration for iOS/macOS debugging.
      -- It must be listed as a dependency so it loads before nvim-dap's config runs.
      'wojciech-kulik/xcodebuild.nvim',

      -- Pretty UI for the debugger: scopes, breakpoints, stack trace, REPL console.
      'rcarriga/nvim-dap-ui',

      -- nvim-nio is an async I/O library required by nvim-dap-ui since v4+.
      -- Without it, dap-ui throws an error on startup.
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- ------------------------------------------------------------------------
      -- Auto-open / close dap-ui panels when debugging starts / ends
      -- ------------------------------------------------------------------------
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- ------------------------------------------------------------------------
      -- dap-ui layout configuration
      -- ------------------------------------------------------------------------
      -- Left side: scopes (variables) + breakpoints + stacks + watches
      -- Bottom: REPL console + app logs
      dapui.setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 10,
            position = 'bottom',
          },
        },
      }

      -- ------------------------------------------------------------------------
      -- xcodebuild.nvim DAP integration
      -- ------------------------------------------------------------------------
      -- This sets up the "lldb" DAP adapter with the correct arguments for
      -- iOS Simulator and physical devices. You do NOT need to configure the
      -- adapter manually — xcodebuild.nvim generates it dynamically based on the
      -- selected scheme / device / project settings.
      local xcodebuild_dap = require 'xcodebuild.integrations.dap'
      xcodebuild_dap.setup()
    end,
  },
}
