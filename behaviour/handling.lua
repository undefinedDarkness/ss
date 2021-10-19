local M = {}

-- Setup item callbacks
function M.setup_item(item, preview, widget)
	function widget.on_clicked()
		item.cb()
	end

	function widget.on_pressed()
		if item.preview then
				local x = preview:get_child()
				-- NOTE: If your preview generation is very slow,
				-- please cache it in your function...
				if x then 
					x:destroy()
				end  
				-- Generate preview on-demand
				preview:add(item.preview(preview))
				preview:show_all()
		else
			preview:hide()
		end
	end
end

function M.setup_all(list, entry, preview, window)

	-- Connect to editing / exiting the search box
	function entry.on_search_changed()
		-- CHANGE this to `search' for normal searching
		require('behaviour.filter').fuzzy_search(entry.text, list)
		require('behaviour.sources').update_list(entry.text, list)
		list:show_all()
	end

	function entry.on_stop_search()
		window:close()
	end

	-- Connect to movement in list
	function list.on_row_activated(_, row)
		row:get_child():clicked()
		Gtk.main_quit()
	end

	function list.on_row_selected(_, row)
		if row then
			row:get_child():pressed()
		end
	end

	function list.on_key_press_event(_, e)
		-- Return
		if (e.keyval == 0xff0d) then
			return
		end

		-- Top / Down
		if (e.keyval ~= 0xff52 or e.keyval ~= 0xff5) then 
			entry:handle_event(e)
			entry:grab_focus_without_selecting()
		end
	end

end

return M
