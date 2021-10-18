#! /usr/bin/env lua

-- Setup package path
local base_path = string.match(arg[0], "^(.-)[^/\\]*$")
package.path = string.format("%s;%s?.lua", package.path, base_path)

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.util.css(base_path) 

local window = Gtk.Window({
	title = "SS",
	default_width = 400,
	default_height = 500,
	resizable = true,
	on_destroy = Gtk.main_quit,
	on_key_press_event = function(_, e)
		-- Escape
		if (e.keyval == 0xff1b) then 
			Gtk.main_quit()
		end
	end,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false,
	resizable = true
})

local preview = Gtk.ScrolledWindow{
	max_content_width =  window.default_width / 2,
	max_content_height = window.default_height,
}
local list = ui.list.init(preview)
local bar, entry = ui.search() 

local widget = Gtk.HBox {
	Gtk.Box({
		homogeneous = false,
		Gtk.ScrolledWindow({
			list,
			min_content_height = window.default_height - 50,
		}),
		bar,
		orientation = Gtk.Orientation.VERTICAL
	}),
	orientation = Gtk.Orientation.HORIZONTAL,
	homogeneous = false,
}
widget:pack_start(preview, false, false, 0) -- TODO: Fix the preview widget...

require('behaviour.handling').setup_all(list, entry, preview, window)
window:add(widget)
window:show_all()
Gtk.main()
