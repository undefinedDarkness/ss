#! /usr/bin/env lua
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

-- Initiate some widgets
local entry = Gtk.SearchEntry({})

local active = Gtk.Label {}
ui.util.class(active, "selected-label")

list = ui.list.init(entry, function(it)
	active.label = it.name
end)

function entry.on_stop_search()
	Gtk.main_quit()
end

function entry.on_search_changed()
	if entry.text:gsub('%s', '') == "" then
		list:show_all()
		return
	end
	require('behaviour.filter').search(entry.text)
	require('behaviour.sources').update(entry.text)
	require('ui.list').reset_selected()
end

-- Main layout
local layout = Gtk.Box({
	homogeneous = false,
	orientation = Gtk.Orientation.HORIZONTAL, -- CHANGE
})
layout:pack_start(entry, false, false, 0)
layout:pack_start(active, false, false, 16)
layout:pack_start(Gtk.ScrolledWindow({ list }), true, true, 0)

local window = ui.window(layout) 
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

window:show_all()
window:present()

-- Start main loop
Gtk.main()
