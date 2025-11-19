local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "synthwave"
config.font_size = 16

config.font = wezterm.font_with_fallback({
	"PlemolJP35 Console NF",
	"Noto Sans JP",
})

config.use_ime = false

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

return config
