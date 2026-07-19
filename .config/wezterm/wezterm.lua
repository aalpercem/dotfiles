local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- General
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.native_macos_fullscreen_mode = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Font
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Symbols Nerd Font Mono",
})
config.font_size = 25

-- Color scheme
config.color_scheme = "rose-pine"

-- Rose Pine colors from built-in scheme (fallback to catppuccin if unavailable)
local scheme = wezterm.color.get_builtin_schemes()["rose-pine"]
  or wezterm.color.get_builtin_schemes()["catppuccin-mocha"]
local c = {
	base = scheme.background,
	surface = scheme.ansi[1],
	overlay = scheme.brights[1],
	text = scheme.ansi[8],
	love = scheme.ansi[2],
	gold = scheme.ansi[4],
	rose = scheme.ansi[7],
	pine = scheme.ansi[3],
	foam = scheme.ansi[5],
	iris = scheme.ansi[6],
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 128

config.colors = {
	selection_fg = c.base,
	selection_bg = c.rose,
	tab_bar = {
		background = c.base,
		inactive_tab = {
			bg_color = c.base,
			fg_color = c.overlay,
		},
		active_tab = {
			bg_color = c.base,
			fg_color = c.rose,
			intensity = "Bold",
		},
		new_tab = {
			bg_color = c.base,
			fg_color = c.overlay,
		},
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local index_bg = c.surface
	local index_fg = c.text
	local title_bg = c.surface
	local title_fg = c.overlay
	local edge_bg = c.base
	local edge_fg = c.surface

	if tab.is_active then
		index_bg = c.love
		index_fg = c.base
		title_bg = c.surface
		title_fg = c.text
		edge_fg = c.love
	elseif hover then
		index_bg = c.rose
		index_fg = c.base
		title_bg = c.surface
		title_fg = c.text
		edge_fg = c.love
	end

	local index = tab.tab_index + 1
	local title = tab.active_pane.title

	-- Truncate if too long
	local max_title = max_width - 2
	if #title > max_title then
		title = title:sub(1, max_title) .. "…"
	end

	return {
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = edge_fg } },
		{ Text = "" },

		{ Background = { Color = index_bg } },
		{ Foreground = { Color = index_fg } },
		{ Text = index .. " " },

		{ Background = { Color = title_bg } },
		{ Foreground = { Color = title_fg } },
		{ Text = " " .. title .. " " },

		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = edge_fg } },
		{ Text = "" },

		{ Background = { Color = edge_bg } },
		{ Text = "  " },
	}
end)

-- Vim split navigation
local function is_vim(pane)
	return pane:get_user_vars().IS_VIM == "true" or pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function split_nav(key, direction)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction }, pane)
			end
		end),
	}
end

-- Keys
config.keys = {
	{
		key = "w",
		mods = "OPT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "f",
		mods = "CTRL|CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "h",
		mods = "OPT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "OPT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	split_nav("h", "Left"),
	split_nav("j", "Down"),
	split_nav("k", "Up"),
	split_nav("l", "Right"),

	-- Tab navigation (Ctrl+Tab / Ctrl+Shift+Tab)
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
}

return config
