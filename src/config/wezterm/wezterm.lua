local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()

-- Colors
config.color_scheme = "Selenized Dark (Gogh)"

-- Fonts
config.font = wezterm.font_with_fallback({
	"Fira Code",
	"Nerd Font Symbols",
})
config.font_size = 13
config.line_height = 1.2

-- Tab bar
config.use_fancy_tab_bar = false

-- Window
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Maximize all windows on startup
wezterm.on("gui-attached", function()
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

return config
