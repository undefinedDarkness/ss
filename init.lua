#! /usr/bin/env lua

-- Main Init Code:
-- Loads libraries
-- Builds initial user interface

-- Initiate package path {{{
	arg = arg or {}
	base_path = string.match(arg[0] or "", "^(.-)[^/\\]*$")
	-- For normal lua
	if base_path and #base_path > 0 then
		package.path = package.path .. ";" .. base_path .. "?.lua;" .. base_path .. "/?/init.lua"
	elseif awesome then
		-- For awesomeWM
		base_path = require('gears.filesystem').get_configuration_dir()..(...):match("%S+"):gsub("%.", "/")..'/' 
		package.path = base_path .. '/?.lua;'..base_path..'/?/init.lua;' .. package.path
	else 
		-- For luaJIT
		package.path = package.path .. ";./?/init.lua"
	end
	-- }}}

local lgi = require("lgi")
Gtk = lgi.require("Gtk", "3.0")

HOME = os.getenv("HOME")

local ui = require("ui")
ui.util.init_css(base_path)

local window = ui.window() 

local preview = Gtk.ScrolledWindow({})
ui.util.class(preview, "preview-panel")

-- Initiate some widgets
local entry = Gtk.SearchEntry({})
local list = ui.list.init(entry, preview)

function entry.on_stop_search()
	Gtk.main_quit()
end

function window:on_key_press_event(e)
	if (e.keyval >= 0xff51 and e.keyval <= 0xff54) or (e.keyval == 0xff0d)  then
		list:grab_focus() 
		list:event(e)
		return true
	elseif e.keyval == 0xff1b then
		print("Exiting")
		Gtk.main_quit()
	end
end


local bar = Gtk.HBox({
	entry,
	homogeneous = false,
})

local widget = Gtk.HBox({})
local item_icon = Gtk.Image{}

-- Create switcher menu
local a = require('behaviour.args')
if not (a.dmenu or a.no_switcher)  then
	widget:pack_start(require('ui.switcher'), false, false, 0)
end

-- Main layout
local layout = Gtk.Box({
	homogeneous = false,
	orientation = Gtk.Orientation.HORIZONTAL, -- CHANGE
})
layout:pack_start(bar, false, false, 0)
layout:pack_start(Gtk.ScrolledWindow({ list }), true, true, 0)
widget:add(layout)

window:add(widget)
window:show_all()
window:present()
-- entry:grab_focus_without_selecting()
widget:add(preview)

-- Start main loop
Gtk.main()
