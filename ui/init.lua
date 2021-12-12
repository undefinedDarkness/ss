return {
	util = require("ui.util"),
	list = require("ui.list"),
	window = function(child)
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
		
		if wt == "center-menu" then
			window:set_position(Gtk.WindowPosition.CENTER)
			window.default_width = 400
			window.default_height = 400
		elseif wt == "sidebar" then
			window:set_size_request(50, 840)
			window:move(0, 0)
		elseif wt == "bar" then
			window:set_size_request(1600, 50)
			window:move(0, 787)
		end

		if not awesome then
			window.on_destroy = Gtk.main_quit
		end

		return window
	end
}
