local Gdk = require('lgi').Gdk

local M = {}

function M.class (widget, class)
	widget:get_style_context():add_class(class)
end

function M.css()
	local provider = Gtk.CssProvider()
	provider:load_from_path('app.css') -- TODO: Error checking here

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
	local bar = Gtk.SearchBar {
		Gtk.Box {
			entry
		}
	}
	bar:set_search_mode(true)
	bar:connect_entry(entry)

	-- Invalidate filter
	-- TODO: Remove a way to clean up irrelevant items..
	function entry.on_search_changed()
		require('behaviour').update_list_by_search(entry.text, list)
		list:invalidate_filter() -- For existing items..
		list:show_all() -- show the new widgets, if any
	end

	list:set_filter_func(function(row)
		return require('behaviour').filter_by_search(entry.text, row:get_child().label)
	end)
	
	-- Chomp every input event the window recieves
	function window.on_key_press_event(_, event)
		bar:handle_event(event)
	end
	return bar
end

-- CHANGE

function M.list_item(item)
	local widget = Gtk.Button.new_with_label(item.name)
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
	return widget --Gtk.Label { label=item.name}
end

function M.list()
	local items = require('sources').apps() -- This might be a bit dumb, idk
	local list = Gtk.ListBox{}
	for _, item in ipairs(items) do
		list:prepend(M.list_item(item))
	end
	function list:on_row_activated(row)
		row:get_child():pressed()
	end
	return list
end

return M
