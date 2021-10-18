#! /usr/bin/env lua

-- Setup package path
local base_path = string.match(arg[0], "^(.-)[^/\\]*$")
package.path = string.format("%s;%s?.lua", package.path, base_path)

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.util.css(base_path) 

local preview = Gtk.ScrolledWindow{
	max_content_width = 500,
	max_content_height = 400 
}
local list = ui.list.init(preview)
local bar, entry = ui.search() 

local widget = Gtk.HBox {
	Gtk.Box({
		homogeneous = false,
		Gtk.ScrolledWindow({
			list,
			min_content_height = 350,
		}),
		bar,
		orientation = Gtk.Orientation.VERTICAL
	}),
	orientation = Gtk.Orientation.HORIZONTAL,
	preview
	-- homogeneous = false,
}
-- widget:pack_end(preview, false, false, 0)

require('behaviour.handling').setup_all(list, entry, preview, ui.window)
ui.window:add(widget)
ui.window:show_all()
Gtk.main()
