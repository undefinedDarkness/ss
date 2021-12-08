local M = { preview = nil }
local Gdk = require("lgi").Gdk

-- CHANGE this to modify the appearance of a single list item,
-- the returned widget needs to have a .id property
-- and .clicked and .pressed methods
-- They are used for calling the callback & triggering the preview
--
-- Item structure:
-- name: string to display
-- cb  : callback if is selected
-- icon: gicon to display
-- preview: string that becomes a tooltip or function that generates widget to display
-- widget: custom widget to display - this isnt a function because its used immediatley
--
-- TODO: I really need to refactor this but I have no idea exactly how
-- Especially the :on_clicked() and :on_pressed() hacks, :(((
-- Which is quite limited and I cant attach more than 2 handlers
function M.list_item(item)
	if not item.name then
		print("Has no name given: ",require("util.inspect")(item))
	end
	item.name = item.name or "<NO NAME GIVEN>"

	-- This is only used to have a active event and hover support
	local widget = Gtk.Button({})
	-- widget:set_size_request(0, 0)

	widget.id = item.name
	require("ui.util").class(widget, "list-item")

	-- Setup triggers
	require("behaviour.handling").setup_item(item, M.preview, widget)

	if item.widget then
		widget:add(item.widget)
		return widget
	end

	local interior = Gtk.Box({})
	widget:add(interior)

	if item.icon then
		local image = Gtk.Image.new_from_gicon(item.icon, Gtk.IconSize.DND)
		image:set_pixel_size(32)
		interior:add(image)
	end

	-- local name = Gtk.Label { label = item.name }
	-- name:set_ellipsize(3)
	-- interior:add(name)
	
	-- if item.source ~= "Application" then
	-- 	local txt = Gtk.Label { label = item.source }
	-- 	require('ui.util').class(txt, "source-text")
	-- 	txt:set_valign(Gtk.Align.START)
	-- 	interior:pack_end(txt, false, false, 0)
	-- end

	return widget
end

function M.init(preview)
	local list = Gtk.ListBox({})
	M.preview = preview -- Store as global for repeated access
	for k, item in ipairs(require("behaviour.sources").startup_source()) do
		list:add(M.list_item(item))
	end
	return list
end

return M
