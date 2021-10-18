return function()
	local entry = Gtk.SearchEntry{}
	-- local count = Gtk.Label {label='0/0'}
	-- require('ui.util').class(count, 'count')
	
	local bar = Gtk.HBox {
		entry,
		homogeneous = false,
	}
	-- bar:pack_end(count, false, false, 0)

	return bar, entry, label
end

