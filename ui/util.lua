local M = {}
local Gdk = require("lgi").Gdk

-- Apply a class to a widget
function M.class(widget, class)
	widget:get_style_context():add_class(class)
	return widget
end

-- Load css from app.css
function M.init_css(base_path)
	local provider = Gtk.CssProvider()
	local err, msg = provider:load_from_path(base_path .. 'ui/themes/' .. require('behaviour.general').arguments.style, err)
	if not err then
		print("CSS Error:  " .. tostring(msg))
	end

	local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
	local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
	Gtk.StyleContext.add_provider_for_screen(screen, provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
end

-- Create application window 
-- and setup structure
function M.create_window()
	local window = Gtk.Window({
		title = "SS",
		default_width = 400,
		default_height = 400,
		resizable = false,
		has_resize_grip = false,
		decorated = false,
	})
	window:set_keep_above(true)
	window:stick()
	window:set_position(Gtk.WindowPosition.CENTER)

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

return M
