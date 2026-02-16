-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- General
config.enable_tab_bar = false

config.font_size = 24
config.color_scheme = "tokyonight_night"

config.native_macos_fullscreen_mode = true

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(0, 0)
  window:gui_window():toggle_fullscreen()
end)

config.keys = {
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = "f",
    mods = "CTRL|CMD",
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
}

return config
