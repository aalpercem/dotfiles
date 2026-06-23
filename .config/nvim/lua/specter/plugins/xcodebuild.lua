-- ============================================================================
-- xcodebuild.nvim — Main plugin for iOS/macOS development inside Neovim
-- ============================================================================
-- WHAT IT DOES:
--   Replaces Xcode for the edit-build-run-test loop. Provides commands to build,
--   run, test, debug, and preview Swift / Obj-C apps for iOS, iPadOS, watchOS,
--   tvOS, visionOS and macOS directly from Neovim.
--
-- DEPENDENCIES (external tools you must install via brew):
--   • xcp               — XcodeProjectCLI, manages .xcodeproj files from CLI
--   • xcode-build-server — Build Server Protocol (BSP) so sourcekit-lsp understands
--                         .xcodeproj / .xcworkspace structure
--   • xcbeautify        — Formats the raw xcodebuild output into readable logs
--   • coreutils         — Required for simulator log streaming without debugger
--   • rg (ripgrep)      — Finds matching test files when using Swift Testing
--   • jq                — Parses JSON output from pymobiledevice3
--   • pipx + pymobiledevice3 — Secure tunnel for debugging on physical iOS 17+ devices
--
-- FIRST TIME PROJECT SETUP:
--   1. Open your project root in Neovim
--   2. Run :XcodebuildSetup (picks project, scheme, device, config)
--   3. Or run in terminal:
--        xcode-build-server config -project <Name>.xcodeproj -scheme "<Scheme>"
--   4. Run :checkhealth xcodebuild to verify everything is green
--
-- COMMANDS YOU WILL USE DAILY:
--   :XcodebuildPicker        — Floating menu with ALL available actions
--   :XcodebuildBuild         — Build the project
--   :XcodebuildBuildRun      — Build & run on selected simulator / device
--   :XcodebuildTest          — Run tests
--   :XcodebuildTestClass     — Run tests for the class under cursor
--   :XcodebuildToggleLogs    — Show / hide build logs panel
--   :XcodebuildToggleCodeCoverage — Show line-by-line coverage after tests
--   :XcodebuildPreviewGenerateAndShow — Generate SwiftUI/UIKit preview
--
-- HIGHLIGHTS:
--   • Test results appear as gutter signs (✔ / ✖) next to test declarations
--   • Test Explorer panel shows a tree of all tests with live status
--   • Build errors populate the quickfix list (use <leader>q or Telescope)
--   • Logs are formatted by xcbeautify in real-time
--   • Auto-saves all buffers before build / test
--
-- NOTE:
--   Preview support requires snacks.nvim (image snack) + xcodebuild-nvim-preview
--   Swift package added to your project. See snacks.lua for Neovim side config.
-- ============================================================================

return {
  {
    'wojciech-kulik/xcodebuild.nvim',
    dependencies = {
      -- Telescope is already installed in your config. xcodebuild.nvim uses it
      -- for pickers (select scheme, device, test target, etc.).
      'nvim-telescope/telescope.nvim',

      -- nui.nvim provides floating windows for the coverage report and some
      -- other UI elements inside xcodebuild.nvim.
      'MunifTanjim/nui.nvim',

      -- nvim-tree integration: automatically updates .xcodeproj when you add,
      -- delete, or rename files through the file tree. See nvimtree.lua.
      'nvim-tree/nvim-tree.lua',
    },
    config = function()
      require('xcodebuild').setup {
        -- Restore previous session (logs, diagnostics, test marks) on VimEnter.
        -- Set to false if startup feels slow on large projects.
        restore_on_start = true,

        -- Automatically save all modified buffers before build / test.
        auto_save = true,

        -- Show a [························] progress bar during build.
        -- Duration is estimated from the previous build.
        show_build_progress_bar = true,

        -- Prepare a list of failing snapshot tests (from swift-snapshot-testing).
        prepare_snapshot_test_previews = true,

        -- How test files are matched to their source counterparts.
        -- "filename_lsp" tries filename heuristic first, then LSP symbols.
        test_search = {
          file_matching = 'filename_lsp',
          target_matching = true, -- verify test file target matches build log
          lsp_client = 'sourcekit',
          lsp_timeout = 200,
        },

        commands = {
          -- Extra arguments passed to `xcodebuild build` and `xcodebuild test`.
          -- -parallelizeTargets speeds up compilation by building targets concurrently.
          extra_build_args = { '-parallelizeTargets' },
          extra_test_args = { '-parallelizeTargets' },

          -- How deep to search for .xcodeproj / .xcworkspace when running the
          -- configuration wizard (:XcodebuildSetup).
          project_search_max_depth = 4,

          -- Automatically bring the Simulator window to front when the app launches.
          focus_simulator_on_app_launch = true,

          -- Device cache: set to true if you want to keep the same simulator selected
          -- even when switching schemes or project files.
          keep_device_cache = false,
        },

        logs = {
          -- When to automatically open the build / test logs panel.
          auto_open_on_success_tests = false,
          auto_open_on_failed_tests = false,
          auto_open_on_success_build = false,
          auto_open_on_failed_build = true, -- show logs immediately when build fails
          auto_close_on_app_launch = false,
          auto_close_on_success_build = false,
          auto_focus = true, -- move cursor into logs panel when it opens

          -- How to open the logs panel: bottom-right 20-line split.
          open_command = 'silent botright 20split {path}',

          -- Log formatter: xcbeautify strips Xcode's noisy metadata and colours output.
          -- --disable-colored-output is required because Neovim's terminal handles colours
          -- differently; --disable-logging removes extra xcodebuild noise.
          logs_formatter = 'xcbeautify --disable-colored-output --disable-logging',

          -- If true, no raw xcodebuild output is shown; only the plugin's summary.
          only_summary = false,

          -- Update the log buffer in real-time while xcodebuild is running.
          live_logs = true,

          -- Include warnings in the logs summary panel.
          show_warnings = true,

          -- Notification function: uses Neovim's built-in vim.notify.
          -- If you have nvim-notify or fidget.nvim, you can override this.
          notify = function(message, severity)
            vim.notify(message, severity)
          end,

          -- Live progress messages (e.g. "Building MyApp [45%]...") echoed to cmdline.
          notify_progress = function(message)
            vim.cmd("echo '" .. message .. "'")
          end,
        },

        console_logs = {
          -- Enable app console logs inside the dap-ui console window.
          -- These are the NSLog / print() statements from your running app.
          enabled = true,
          format_line = function(line)
            return line
          end,
          filter_line = function(line)
            return true
          end,
        },

        marks = {
          -- Gutter signs next to each test declaration showing pass / fail.
          show_signs = true,
          success_sign = '✔',
          failure_sign = '✖',
          show_test_duration = true, -- e.g. "0.04s" next to the test name
          show_diagnostics = true,   -- add test failures to vim diagnostics
        },

        quickfix = {
          -- Populate the quickfix list with build / test errors and warnings.
          show_errors_on_quickfixlist = true,
          show_warnings_on_quickfixlist = true,
        },

        test_explorer = {
          -- Side panel showing a tree of all tests (target → class → test).
          enabled = true,
          auto_open = true,  -- open when tests start
          auto_focus = true, -- jump cursor into the panel when it opens
          open_command = 'botright 42vsplit Test Explorer',
          open_expanded = true,
          success_sign = '✔',
          failure_sign = '✖',
          progress_sign = '…',
          disabled_sign = '⏸',
          partial_execution_sign = '‐',
          not_executed_sign = ' ',
          show_disabled_tests = false,
          animate_status = true, -- spinning animation while tests run
          cursor_follows_tests = true, -- jump to the last executed test
        },

        code_coverage = {
          -- Inline coverage signs after running tests with coverage enabled.
          enabled = false, -- toggle on with :XcodebuildToggleCodeCoverage
          file_pattern = '*.swift',
          covered_sign = '',
          partially_covered_sign = '┃',
          not_covered_sign = '┃',
          not_executable_sign = '',
        },

        code_coverage_report = {
          warning_coverage_level = 60,
          error_coverage_level = 30,
          open_expanded = false,
        },

        project_manager = {
          -- When you create a new file, guess its Xcode target based on path.
          guess_target = true,
          find_xcodeproj = false, -- use configured project instead of searching
          should_update_project = function(path)
            return true
          end,
          project_for_path = function(path)
            return nil
          end,
        },

        previews = {
          -- Window command used when generating SwiftUI / UIKit previews.
          -- Splits vertically on the right, 50 columns wide.
          open_command = 'vertical botright split +vertical\\ resize\\ 50 %s | wincmd p',
          show_notifications = true,
        },

        device_picker = {
          mappings = {
            move_up_device = '<M-y>',
            move_down_device = '<M-e>',
            add_device = '<M-a>',
            delete_device = '<M-d>',
            refresh_devices = '<C-r>',
          },
        },

        macro_picker = {
          -- Swift Macros must be explicitly approved for security. When a build
          -- fails because of an unapproved macro, this picker pops up automatically.
          auto_show_on_error = true,
          mappings = {
            approve_macro = '<C-a>',
          },
        },

        integrations = {
          -- pymobiledevice3: secure tunnel for debugging physical iOS 17+ devices.
          -- Requires pymobiledevice3 installed via pipx. See wiki for sudo setup.
          pymobiledevice = {
            enabled = true,
            remote_debugger_port = 65123,
          },

          -- xcodebuild_offline: caches build settings to speed up builds on Xcode < 26.
          -- Enable if you are on an older Xcode version and builds feel slow.
          xcodebuild_offline = {
            enabled = false,
          },

          -- xcode_build_server: automatically re-run `xcode-build-server config` when
          -- the scheme changes. This keeps sourcekit-lsp in sync with the project.
          xcode_build_server = {
            enabled = true,
            guess_scheme = true,
          },

          -- File-tree integrations: when enabled, adding / deleting / renaming files
          -- through nvim-tree, neo-tree, or oil.nvim automatically updates the
          -- .xcodeproj file so you never have to open Xcode again.
          nvim_tree = {
            enabled = true,
          },
          neo_tree = {
            enabled = false, -- not installed in this config
          },
          oil_nvim = {
            enabled = false, -- not installed in this config
          },

          -- Quick framework (BDD testing) support.
          quick = {
            enabled = true,
          },

          -- Telescope picker integration for all xcodebuild.nvim pickers.
          telescope_nvim = {
            enabled = true,
          },

          -- Snacks.nvim picker integration (alternative to telescope).
          -- Disabled here because we already use telescope in this config.
          snacks_nvim = {
            enabled = false,
            layout = nil,
          },

          -- fzf-lua picker integration (alternative to telescope).
          fzf_lua = {
            enabled = false,
            fzf_opts = {},
            win_opts = {},
          },

          -- codelldb: legacy adapter for Xcode < 16. Since Xcode 16 ships with the
          -- native lldb-dap, this is disabled by default.
          codelldb = {
            enabled = false,
            port = 13000,
            codelldb_path = nil,
            lldb_lib_path = '/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB',
          },

          -- lldb-dap: native DAP adapter shipped with Xcode 16+. No extra install needed.
          -- xcodebuild.nvim uses this by default for the nvim-dap integration.
          lldb = {
            port = 13000,
          },
        },
      }
    end,
  },
}
