return  Gtk.Window({
	title = "SS",
	default_width = 400,
	default_height = 300,
	on_destroy = Gtk.main_quit,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false,
})
