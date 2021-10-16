local Gdk = require('lgi').Gdk
-- require() ing behaviour here as a global wont work,
-- it gives some weird C levels error
-- so dont do that :)
local M = {}

function M.class (widget, class)
	widget:get_style_context():add_class(class)
end

function M.css(base_path)
	local provider = Gtk.CssProvider()
	local err, msg = provider:load_from_path(base_path..'app.css', err) 
	if not err then
		print("CSS Error:  "..tostring(msg))
	end

	local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
	local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
	Gtk.StyleContext.add_provider_for_screen(
	screen,
	provider,
	GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
	)
end

function M.search_bar(window, list)
	local entry = Gtk.SearchEntry{}
	local bar = Gtk.Box {
		entry,
		homogeneous = true
	}

	-- TODO: This has a slight delay which feels sorta sluggish..
	function entry.on_search_changed()

		-- CHANGE this to `filter_by_search' for normal starts-with searching
		require('behaviour').filter_by_fuzzy_search(list, entry.text)
		require('behaviour').update_list_by_search(entry.text, list)
	end

	function entry.on_stop_search()
		window:close()
	end

	-- See: https://gitlab.gnome.org/GNOME/gtk/blob/master/gdk/gdkkeysyms.h
	function window.on_key_press_event(_, e)
		if (e.keyval == 0xff1b) then -- Escape
			window:close()
		end
	end

	function list.on_key_press_event(_, e)
		if (e.keyval ~= 0xff52 or e.keyval ~= 0xff5) then -- Up / Down
			entry:handle_event(e)
			entry:grab_focus_without_selecting()
		end
	end

	return bar
end

-- CHANGE this to modify the appearance of a single list item,
-- the returned widget needs to have a .label property
function M.list_item(item)
	local widget = Gtk.Button.new_with_label(item.name)
	widget:set_visible(true)
	function widget.on_pressed()
		item.cb()
		Gtk.main_quit()
	end
	widget:set_alignment(0, 0)
	if item.icon then
		widget:set_always_show_image(true)
		local image = Gtk.Image.new_from_gicon(item.icon, Gtk.IconSize.DND)
		image:set_pixel_size(32) 
		widget:set_image(image)
	end
	return widget 
end

-- CHANGE this to modify the layout in which items are shown
-- or the items added at startup
function M.list()
	local list = Gtk.ListBox{}
	
	function list.on_row_activated(_, row)
		row:get_child():pressed()
	end
	
	for k, item in ipairs(require('util.tbl').contains(arg, '-dmenu') and require('sources').dmenu() or require('sources').apps()) do
		list:add(M.list_item(item))
	end
	return list
end

return M
