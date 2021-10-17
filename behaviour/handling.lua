local M = {}

function M.setup_all(x)

	function x.entry.on_search_changed()
		-- CHANGE this to `fuzzy_search' for fuzzy searching
		require('behaviour.filter').search(x.entry.text, x.list)
		require('behaviour.sources').update_list(x.entry.text, x.list)
		x.list:show_all()
	end

	function x.entry.on_stop_search()
		x.window:close()
	end

	function x.list.on_key_press_event(_, e)
		-- Up / Down / Return
		if (e.keyval == 0xff0d) then
			return
		end
		if (e.keyval ~= 0xff52 or e.keyval ~= 0xff5) then 
			x.entry:handle_event(e)
			x.entry:grab_focus_without_selecting()
		end
	end

end

return M
