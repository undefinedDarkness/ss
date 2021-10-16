#! /usr/bin/env lua

-- Setup package path
local base_path = string.match(arg[0], "^(.-)[^/\\]*$")
package.path = string.format("%s;%s?.lua", package.path, base_path)

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.css(base_path) -- load css

local window = Gtk.Window({
	title = "SS",
	default_width = 400,
	default_height = 300,
	on_destroy = Gtk.main_quit,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false,
})
local list = ui.list()
local widget = Gtk.VBox({
	homogeneous = false,
	ui.search_bar(window, list),
	Gtk.ScrolledWindow({
		list,
		min_content_height = 350,
	}),
})
window:add(widget)
window:show_all()
Gtk.main()
