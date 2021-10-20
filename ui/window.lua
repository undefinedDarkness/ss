return Gtk.Window({
	title = "SS",
	default_width = 800,
	default_height = 500,
	resizable = true,
	on_destroy = Gtk.main_quit,
	on_key_press_event = function(_, e)
		-- Escape
		if e.keyval == 0xff1b then
			Gtk.main_quit()
		end
	end,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false,
})
