local src = require("sources")
local Gio = require("lgi").Gio
local GLib = require("lgi").GLib
local tbl = require("util.tbl")
local ui = require("ui")
local M = {}

-- CHANGE this to modify active sources, and the bangs used for each source
-- TODO: Full forms.. again
M.enabled_sources = src 

-- CHANGE source to be used at startup
-- TODO: Allow multiple sources here
if require("behaviour.general").arguments.dmenu then
	M.startup_source = src.dmenu
else
	M.startup_source = src.apps
end

--  Disable / Enable a source by name
function M.disable_source(source)
	tbl.remove_by_value(M.enabled_sources, source)
end

function M.enable_source(source)
	if not tbl.contains(M.enabled_sources, source) then
	table.insert(M.enabled_sources, source)
end
end

local cancel = nil
-- Note: This is the place where performance goes to die
-- its all really bad code but I'm too stupid to fix it
function M.update_list(search, list)
	-- Cancel any existing tasks
	if cancel then
		cancel:cancel()
	end
	cancel = Gio.Cancellable.new()

	function add_item(item)
		list:add(ui.list.list_item(item))
	end

	-- Check and use bangs if any
	local bang, action = search:match("!(%w+)%s(.*)")
	local exists, source = tbl.contains(M.enabled_sources, nil, function(x) return x.full_form == bang or x.bang == bang end)
	if  exists then
		Gio.Async.start(source[1], cancel)(add_item, action, true, cancel)
	else
		-- Normally loop through every source
		for _, source in ipairs(M.enabled_sources) do
			Gio.Async.start(source[1], cancel)(add_item, search, false, cancel)
		end
	end
end

return M
