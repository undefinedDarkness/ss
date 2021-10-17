return function()
	local entry = Gtk.SearchEntry{}
	local bar = Gtk.HBox {
		entry,
		homogeneous = false,
	}
	return bar, entry
end

