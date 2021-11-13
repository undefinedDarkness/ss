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

local ui = require("ui")
ui.util.init_css(base_path)

local window = ui.util.create_window() 

-- Create preview window {{{
local preview = Gtk.ScrolledWindow({})
ui.util.class(preview, "preview-panel")
function preview:on_show()
	window:resize(800, window.default_height)
end
function preview:on_hide()
	window:resize(400, window.default_height)
end
-- }}}

local list = ui.list.init(preview)
local bar, entry = ui.search()

local widget = Gtk.HBox({})

-- If is running in dmenu mode
-- disable mode switcher
-- CHANGE uncomment to enable
if not require('behaviour.general').arguments.dmenu  then
	widget:pack_start(require('ui.switcher'), false, false, 0)
end

widget:add(
Gtk.Box({
	homogeneous = false,
	bar,
	Gtk.ScrolledWindow({
		list,
		min_content_height = window.default_height - 50,
	}),
	orientation = Gtk.Orientation.VERTICAL,
}))

-- Setup event handling and passing between widgets
require("behaviour.handling").setup_all(list, entry, preview, window)
window:add(widget)
window:show_all()
widget:add(preview) -- To not be shown by default
entry:grab_focus_without_selecting()

-- Start main loop
Gtk.main()
