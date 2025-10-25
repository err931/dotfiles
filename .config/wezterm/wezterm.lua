local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "synthwave"
config.font_size = 16

config.font = wezterm.font_with_fallback({
	"PlemolJP35 Console NF",
	"Noto Sans JP",
})

config.use_ime = false
config.hide_tab_bar_if_only_one_tab = true

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

local act = wezterm.action
config.keys = {
	{
		key = "F",
		mods = "SHIFT|CTRL",
		action = act.ToggleFullScreen,
	},
}

return config
