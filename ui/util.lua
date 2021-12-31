-- User Interface Utilities

local M = {}
local Gdk = require("lgi").Gdk

-- Apply a class to a widget
function M.class(widget, class)
	widget:get_style_context():add_class(class)
	return widget
end

function M.rclass(widget, class)
	widget:get_style_context():remove_class(class)
	return widget
end

-- Load css from app.css
function M.init_css(base_path)
	local provider = Gtk.CssProvider()
	local err, msg = provider:load_from_path(base_path .. 'ui/themes/' .. require('behaviour.args').theme..'.css', err)
	if not err then
		print("CSS Error:  " .. tostring(msg))
	end

	local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
	local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
	Gtk.StyleContext.add_provider_for_screen(screen, provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
end

local bar_size = 50
function M.init_window(child)
		local window = Gtk.Window({
			title = "Switcher",
			resizable = false,
			has_resize_grip = false,
			decorated = false,
			child,
		})
		window:set_keep_above(true)
		window:stick()
		local wt = require('behaviour.args').type
		local screen_size = Gdk.Monitor.get_workarea(Gdk.Display.get_primary_monitor(Gdk.Display.get_default()))
		
		if wt == "center-menu" then
			window:set_position(Gtk.WindowPosition.CENTER)
			window.default_width = 400
			window.default_height = 400
		elseif wt == "sidebar" then
			window:set_size_request(50, 840)
			window:move(0, 0)
		elseif wt == "bar" then
			window:set_size_request(screen_size.width, bar_size)
		end

		if not awesome then
			window.on_destroy = Gtk.main_quit
		end

		function window.on_show()
			window:move(0, screen_size.height-bar_size)
		end

		return window
end

return M
