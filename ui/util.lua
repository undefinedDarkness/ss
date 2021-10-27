local M = {}
local Gdk = require("lgi").Gdk

-- Apply a class to a widget
function M.class(widget, class)
	widget:get_style_context():add_class(class)
	return widget
end

-- Load css from app.css
function M.css(base_path)
	local provider = Gtk.CssProvider()
	-- print(base_path .. "app.css")
	local err, msg = provider:load_from_path(base_path .. "app.css", err)
	if not err then
		print("CSS Error:  " .. tostring(msg))
	end

	local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
	local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
	Gtk.StyleContext.add_provider_for_screen(screen, provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
end

return M
