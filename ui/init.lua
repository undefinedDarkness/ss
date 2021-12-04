return {
	util = require("ui.util"),
	list = require("ui.list"),
	window = function()
		local window = Gtk.Window({
			title = "SS",
			resizable = false,
			has_resize_grip = false,
			decorated = false,
		})
		window:set_keep_above(true)
		window:stick()
		local wt = require('behaviour.args').type
		if wt == "center-menu" then
			window:set_position(Gtk.WindowPosition.CENTER)
			window.default_width = 400
			window.default_height = 400
		elseif wt == "sidebar" then
			window.default_width = 400
			window.default_height = 830
			window:move(0, 0)
		end

		if not awesome then
			window.on_destroy = Gtk.main_quit
		end

		function window:on_key_press_event(_, e)
			-- Escape
			if e and e.keyval == 0xff1b then
				self:close()
			end
		end

		return window
	end
}
