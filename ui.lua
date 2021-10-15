local Gdk = require('lgi').Gdk

local M = {}
-- CHANGE

function M.class (widget, class)
	widget:get_style_context():add_class(class)
end

function M.css()
	local provider = Gtk.CssProvider()
	assert(provider:load_from_path('app.css'), 'ERROR: app.css not found') -- TODO: make sure is using correct path...

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
	-- bar:set_search_mode(true)
	-- bar:connect_entry(entry)

	-- Invalidate filter
	-- TODO: This has a slight delay which feels sorta sluggish..
	function entry.on_search_changed()
		require('behaviour').filter_by_search(list, entry.text, items)
		require('behaviour').update_list_by_search(entry.text, list)
		-- list:show_all() -- show the new widgets, if any
	end

	function entry.on_stop_search()
		window:close()
	end

	-- list:set_filter_func(function(row)
	-- 	return require('behaviour').filter_by_search(entry.text, row:get_child().label, items)
	-- end)

	return bar
end

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

function M.list()
	local list = Gtk.VBox{}
	for k, item in ipairs(require('sources').apps()) do
		list:add(M.list_item(item))
	end
	-- function list:on_row_activated(row)
	-- 	row:get_child():pressed()
	-- end
	return list
end

return M
