local src = require("sources")
local Gio = require("lgi").Gio
local GLib = require("lgi").GLib
local tbl = require("util.tbl")
local ui = require("ui")
local M = {}

-- CHANGE this to modify active sources, and the bangs used for each source
-- TODO: Full forms.. again
M.enabled_sources = {
	m = src.math,
	f = src.file,
	["if"] = src.in_file,
}

-- CHANGE source to be used at startup
if tbl.contains(arg, "--dmenu") then
	M.startup_source = src.dmenu()
else
	M.startup_source = src.apps()
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
	if bang and #bang > 0 and tbl.key_contains(M.enabled_sources, bang) then
		Gio.Async.start(M.enabled_sources[bang], cancel)(add_item, action, true)
	else
		-- Normally loop through every source
		for _, source in pairs(M.enabled_sources) do
			Gio.Async.start(source, cancel)(add_item, search, false)
		end
	end
end

return M
