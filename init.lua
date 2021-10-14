#! /usr/bin/env lua

local lgi = require 'lgi'
Gtk = lgi.require('Gtk')

local ui = require('ui')
ui.css() -- load css

local window = Gtk.Window {
	title = 'Super Switcher',
	default_width = 400,
	default_height = 300,
	on_destroy = Gtk.main_quit,
	has_resize_grip = true
}
local list = ui.list()
local widget = Gtk.VBox {
		homogeneous = false,
		ui.search_bar(window, list),
		list
	}
	window:add(widget)
window:show_all()
require('inspect')(lgi)
Gtk.main()
