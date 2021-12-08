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

local ui = require("ui")
ui.util.init_css(base_path)

local window = ui.window() 

local preview = Gtk.ScrolledWindow({})
ui.util.class(preview, "preview-panel")
-- function preview:on_show()
-- 	window:resize(800, window.default_height)
-- end
-- function preview:on_hide()
-- 	window:resize(400, window.default_height)
-- end

-- Initiate some widgets
local list = ui.list.init(preview)
local entry = Gtk.SearchEntry({})

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
	orientation = Gtk.Orientation.VERTICAL,
})
layout:pack_start(Gtk.ScrolledWindow({ list }), true, true, 0)
-- layout:pack_start(bar, false, false, 0)
widget:add(layout)

-- Setup event handling and passing between widgets
require("behaviour.handling").setup_all(list, entry, preview, window)
window:add(widget)
window:show_all()
widget:add(preview)

-- Start main loop
Gtk.main()
