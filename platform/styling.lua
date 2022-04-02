return {
	load_stylesheet = function(path)
		local provider = Gtk.CssProvider()
		assert(provider:load_from_path(path), "ERROR: " .. path .. "not found")

		local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
		Gtk.StyleContext.add_provider_for_screen(screen, provider, 600)
	end,

    class = function(class, widget)
      widget:get_style_context():add_class(class)
    end
}
