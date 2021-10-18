local M = {}
function M.setup_all(list, entry, preview, window)

	function entry.on_search_changed()
		-- CHANGE this to `search' for normal searching
		require('behaviour.filter').fuzzy_search(entry.text, list)
		require('behaviour.sources').update_list(entry.text, list)
		list:show_all()
	end

	function entry.on_stop_search()
		window:close()
	end

	-- TODO: Use a more robust way to attach functions
	-- to a item widget, this is way too much of a hack
	-- and will only work on buttons...
	-- or simply store the callbacks in a widget
	function list.on_row_activated(_, row)
		row:get_child():clicked()
	end

	function list.on_row_selected(_, row)
		if row then
			row:get_child():pressed()
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

end

return M
