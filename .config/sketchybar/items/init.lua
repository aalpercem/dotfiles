local colors = require("colors")

-- ──────────────────────────── LEFT ────────────────────────────
require("items.apple")
require("items.spaces")

-- ──────────────── CENTER ──────────────────────────────────────
require("items.media")
require("items.weather")
require("items.calendar")

require("items.widgets.volume")
require("items.widgets.wifi")

-- ══════════════════════════════════════════════════════════════
-- BRACKETS — drawn after all items are created
-- ══════════════════════════════════════════════════════════════

CORNER_RADIUS = 16

-- Left pill: Apple logo + Aerospace workspaces
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad" }, {
	background = {
		color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})

-- Center pill: media + weather + time/date
sbar.add("bracket", "bracket.center", {
	"/^center\\.media.*/",
	"center.weather",
	"center.time",
	"center.date",
}, {
	background = {
		color = colors.bg3,
		corner_radius = 4,
		height = 24,
		border_width = 0,
	},
})

-- Right pill: WiFi + Volume
sbar.add("bracket", "bracket.right", {
	"widgets.wifi",
	"widgets.volume",
}, {
	background = {
		color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})
