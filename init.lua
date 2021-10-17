#! /usr/bin/env lua

-- Setup package path
local base_path = string.match(arg[0], "^(.-)[^/\\]*$")
package.path = string.format("%s;%s?.lua", package.path, base_path)

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.util.css(base_path) 

local list = ui.list.init()
local widget = Gtk.VBox({
	homogeneous = false,
	ui.search(ui.window, list),
	Gtk.ScrolledWindow({
		list,
		min_content_height = 350,
	}),
})
ui.window:add(widget)
ui.window:show_all()
Gtk.main()
