local lgi  =require('lgi')
local Gdk = lgi.Gdk
local c = require('ui.util')
local M = {}

-- Item structure:
-- name   : String to display
-- cb     : Callback if is selected
-- source : Type of result
-- icon   : Gicon to display
-- preview: String that becomes a tooltip or function that generates widget to display
-- widget : Custom widget to display - this isnt a function because its used immediatley
-- TODO   : Cleanup some of this with a subclass

M.state = {}
local update_active = nil
function M.register_item(item)
	if not item.widget then
		item.widget = Gtk.Box {}
		if item.icon then
			local image
			if lgi.Gio.Icon:is_type_of(item.icon) then
				image = Gtk.Image.new_from_gicon(item.icon, Gtk.IconSize.DND)
			elseif lgi.Gdk.Pixbuf:is_type_of(item.icon) then
				image = Gtk.Image.new_from_pixbuf(item.icon)
			end
			image:set_pixel_size(32)
			item.widget:add(image)
		end
	end
	local index = #M.state + 1
	M.state[index] = item
	if index == 1 then
		require('ui.util').class(item.widget, 'selected')
		M.state.active = item.widget
		update_active(item)
	end
	item.widget.id = index 
	return c.class(item.widget, 'item')
end

function M.reset_selected()
	local l = list:get_children()
	local t = false

	for _, child in ipairs(l) do
		c.rclass(child, 'selected')
		
		if t == false and child.visible == true then
			t = true
			c.class(child, 'selected')
			M.state.active = child
			update_active(M.state[child.id])
		end
	end
	
end

function M.init(entry, e)
	update_active = e 

	local list = Gtk.Box({
		spacing = 0, -- CHANGE: To increase spacing between items
		orientation = Gtk.Orientation.HORIZONTAL -- CHANGE: to VERTICAL if you want
	})
	for k, item in ipairs(require("behaviour.sources").startup()) do
		list:add(M.register_item(item, preview))
	end

	function list:on_key_press_event(e)
		if e.keyval == 0xff53 or e.keyval == 0xff52 then
			M.state.active = M.state[c.rclass(M.state.active, "selected").id + 1]

			-- Assume at least one item always exists
			if M.state.active == nil then
				M.state.active = M.state[1]
			end
			update_active(M.state.active)
			M.state.active = M.state.active.widget
			c.class(M.state.active, "selected")
			
		elseif e.keyval == 0xff54 or e.keyval == 0xff51 then
			local item = M.state[M.state.active.id - 1]
			if item == nil then
				entry:grab_focus()
				return
			end
			
			c.rclass(M.state.active, 'selected')
			M.state.active = item.widget
			c.class(M.state.active, "selected")
			
			update_active(item)
		elseif e.keyval == 0xff0d then
			M.state[M.state.active.id].cb()
			Gtk.main_quit()
		end
	end

	return list
end

return M
