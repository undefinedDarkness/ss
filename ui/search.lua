return function(window, list)
	local entry = Gtk.SearchEntry{}
	local bar = Gtk.HBox {
		entry,
		homogeneous = false,
	}

	function entry.on_search_changed()
		-- CHANGE this to `fuzzy_search' for fuzzy searching
		require('behaviour.filter').search(list, entry.text)
		require('behaviour.sources').update_list(entry.text, list)
		list:show_all()
	end

	function entry.on_stop_search()
		window:close()
	end

	-- See: https://gitlab.gnome.org/GNOME/gtk/blob/master/gdk/gdkkeysyms.h
	function window.on_key_press_event(_, e)
		-- Escape
		if (e.keyval == 0xff1b) then 
			window:close()
		end
	end

	function list.on_key_press_event(_, e)
		-- Up / Down / Return
		if (e.keyval == 0xff0d) then
			return
		end
		if (e.keyval ~= 0xff52 or e.keyval ~= 0xff5) then 
			entry:handle_event(e)
			entry:grab_focus_without_selecting()
		end
	end

	return bar
end

