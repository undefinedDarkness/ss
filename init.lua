#! /usr/bin/env lua

-- Setup package path
base_path = string.match(arg[0], "^(.-)[^/\\]*$")
if base_path and #base_path > 0 then
	package.path = package.path .. ";" .. base_path .. "?.lua;" .. base_path .. "/?/init.lua"
else
	package.path = package.path .. ";./?/init.lua"
end

local lgi = require("lgi")
Gtk = lgi.require("Gtk")

local ui = require("ui")
ui.util.css(base_path)

local window = Gtk.Window({
	title = "SS",
	default_width = 400,
	default_height = 400,
	resizable = true,
	on_destroy = Gtk.main_quit,
	on_key_press_event = function(_, e)
		-- Escape
		if e.keyval == 0xff1b then
			Gtk.main_quit()
		end
	end,
	has_resize_grip = true,
	window_position = Gtk.WindowPosition.CENTER,
	decorated = false,
	resizable = true,
})

local preview = Gtk.ScrolledWindow({})
require("ui.util").class(preview, "preview-panel")
function preview:on_show()
	window:resize(800, window.default_height)
end
function preview:on_hide()
	window:resize(400, window.default_height)
end

local list = ui.list.init(preview)
local bar, entry = ui.search()

local widget = Gtk.HBox({
	Gtk.Box({
		homogeneous = false,
		bar,
		Gtk.ScrolledWindow({
			list,
			min_content_height = window.default_height - 50,
		}),
		orientation = Gtk.Orientation.VERTICAL,
	}),
	orientation = Gtk.Orientation.HORIZONTAL,
	homogeneous = true,
})

require("behaviour.handling").setup_all(list, entry, preview, window)
window:add(widget)
window:show_all()
widget:add(preview)
Gtk.main()
