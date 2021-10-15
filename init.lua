#! /usr/bin/env lua

local lgi = require 'lgi'
Gtk = lgi.require('Gtk')

local ui = require('ui')
ui.css() -- load css

local window = Gtk.Window {
	title = 'SS',
	default_width = 400,
	default_height = 300,
	on_destroy = Gtk.main_quit,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false
}
local list = ui.list()
local widget = Gtk.VBox {
		homogeneous = false,
		ui.search_bar(window, list),
		Gtk.ScrolledWindow {
			list,
			min_content_height = 350
		}
	}
	window:add(widget)
window:show_all()
require('inspect')(lgi)
Gtk.main()
