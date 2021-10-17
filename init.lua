#! /usr/bin/env lua

-- Setup package path
local base_path = string.match(arg[0], "^(.-)[^/\\]*$")
package.path = string.format("%s;%s?.lua", package.path, base_path)

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.util.css(base_path) 

local preview = Gtk.Frame{}
local list = ui.list.init()
local bar, entry = ui.search() 
-- TODO: maybe use global vars instead of this passing thing? might be a bit more icky tho
local widget = Gtk.HBox {
	Gtk.VBox({
		homogeneous = false,
		Gtk.ScrolledWindow({
			list,
			min_content_height = 350,
		}),
		bar,
	}),
	homogeneous = false,
	preview
}
require('behaviour.handling').setup_all({
	entry = entry,
	window = ui.window,
	preview = preview,
	list = list
})
ui.window:add(widget)
ui.window:show_all()
Gtk.main()
