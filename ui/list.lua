local Gdk = require("lgi").Gdk
local c = require('ui.util')
local M = {}

-- Item structure:
-- name   : String to display
-- cb     : Callback if is selected
-- source : Type of result
-- icon   : Gicon to display
-- preview: String that becomes a tooltip or function that generates widget to display
-- widget : Custom widget to display - this isnt a function because its used immediatley

local state = {}
function M.register_item(item)
	if not item.widget then
		item.widget = Gtk.Box {}
		if item.icon then
			local image = Gtk.Image.new_from_gicon(item.icon, Gtk.IconSize.DND)
			image:set_pixel_size(32)
			item.widget:add(image)
		end
	end
	local index = #state + 1
	state[index] = item
	if index == 1 then
		require('ui.util').class(item.widget, 'selected')
		state.active = item.widget
	end
	item.widget.id = index 
	return c.class(item.widget, 'item')
end

function M.init(entry, preview)
	local list = Gtk.Box({
		spacing = 0, -- CHANGE: To increase spacing between items
		orientation = Gtk.Orientation.HORIZONTAL -- CHANGE: to VERTICAL if you want
	})
	for k, item in ipairs(require("behaviour.sources").startup_source()) do
		list:add(M.register_item(item, preview))
	end

	local event = Gtk.EventBox { list }
	event:add_events(Gdk.EventMask.KEY_PRESS_MASK)
	event:set_can_focus(true)

	function event:on_key_press_event(e)
		if e.keyval == 0xff53 or e.keyval == 0xff52 then
			state.active = state[c.rclass(state.active, "selected").id + 1]

			-- Assume at least one item always exists
			if state.active == nil then
				state.active = state[1]
			end
			state.active = state.active.widget

			c.class(state.active, "selected")
		elseif e.keyval == 0xff54 or e.keyval == 0xff51 then
			local item = state[state.active.id - 1]
			if item == nil then
				entry:grab_focus()
				return
			end
			
			c.rclass(state.active, 'selected')
			state.active = item.widget
			c.class(state.active, "selected")
		elseif e.keyval == 0xff0d then
			state[state.active.id].cb()
			Gtk.main_quit()
		end
	end

	return event
end

return M
