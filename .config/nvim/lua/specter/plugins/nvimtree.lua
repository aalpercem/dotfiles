-- ============================================================================
-- nvim-tree.lua — File explorer with Xcode project auto-sync
-- ============================================================================
-- WHAT IT DOES:
--   A side-panel file tree (like VS Code's Explorer) that integrates with
--   xcodebuild.nvim. When you create, delete, or rename a file through the tree,
--   the corresponding .xcodeproj file is updated automatically. This means you
--   never have to open Xcode just to add a new Swift file to a target.
--
-- DEPENDENCIES:
--   • xcp (XcodeProjectCLI) — installed via brew, used behind the scenes by
--     xcodebuild.nvim to modify .pbxproj files safely.
--   • xcodebuild.nvim — handles the actual project file updates.
--
-- KEYMAPS (global, defined in keymaps.lua):
--   <leader>e  — Toggle nvim-tree
--
-- BUILT-IN NVIM-TREE KEYMAPS (inside the tree buffer):
--   a          — Add file / directory
--   d          — Delete file / directory
--   r          — Rename file / directory
--   <CR>       — Open file
--   R          — Refresh tree
--   q          — Close tree
--
-- NOTE:
--   If you prefer oil.nvim (buffer-as-file-manager workflow), we can swap this
--   module later. Both are supported by xcodebuild.nvim.
-- ============================================================================

return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      -- File-type icons inside the tree (e.g. Swift, JSON, asset icons).
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    config = function()
      require('nvim-tree').setup {
        -- Update the tree automatically when files change outside Neovim
        -- (e.g. git checkout, external build tools).
        auto_reload_on_write = true,

        -- Disable netrw (Neovim's built-in file explorer) so nvim-tree is the
        -- only file manager. Prevents conflicts.
        disable_netrw = true,
        hijack_netrw = true,

        -- Respect gitignore rules when showing / hiding files.
        git = {
          enable = true,
          ignore = true,
        },

        -- Show file-type icons and git status signs (modified, staged, etc.).
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },

        -- Floating diagnostics: show if a file has errors before you open it.
        diagnostics = {
          enable = true,
          show_on_dirs = true,
        },

        -- Actions when creating / removing / renaming files.
        -- xcodebuild.nvim hooks into these events to keep .xcodeproj in sync.
        actions = {
          open_file = {
            -- Close the tree when opening a file so the editor has full width.
            quit_on_open = false,
            resize_window = true,
          },
        },

        -- Filters: hide common non-source files from the tree to reduce noise.
        filters = {
          dotfiles = false,
          custom = {
            '^.git$',
            '^.DS_Store$',
            '^build$',
            '^.build$',
            '^DerivedData$',
          },
        },
      }
    end,
  },
}
