local M = {}
local Gdk = require('lgi').Gdk

-- CHANGE this to modify the appearance of a single list item,
-- the returned widget needs to have a .label property
-- Item structure:
-- name: string to display
-- cb  : callback if is selected
-- icon: gicon to display
-- widget: custom widget to display
function M.list_item(item)
	item.name = item.name or "<NO NAME GIVEN>"
	
	-- This is only used to have a active event and hover support
	local widget = Gtk.Button{} 
	
	widget.id = item.name
	require('ui.util').class(widget, 'list-item')

	function widget.on_clicked()
		item.cb()
		Gtk.main_quit()
	end
	
	if item.widget then 
		widget:add(item.widget)
		return widget
	end

	local interior = Gtk.Box{}
	widget:add(interior)
	
	if item.icon then
		local image = Gtk.Image.new_from_gicon(item.icon, Gtk.IconSize.DND)
		image:set_pixel_size(32) 
		interior:add(image)
	end
	
	interior:add(Gtk.Label { label = item.name })
	return widget 
end

-- CHANGE this to modify the layout in which items are shown
-- or the items added at startup
function M.init()
	local list = Gtk.ListBox{}

	function list.on_row_activated(_, row)
		row:get_child():activate()
	end
	
	for k, item in ipairs(require('behaviour.sources').startup_source) do
		list:add(M.list_item(item))
	end
	return list
end

return M
