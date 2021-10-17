local src = require("sources")
local Gio = require('lgi').Gio
local tbl = require('util.tbl')
local ui = require('ui')
local M = {}

-- CHANGE this to modify active sources, and the bangs used for each source
-- TODO: Support a full form of a bang
M.enabled_sources = {
	m = src.math,
	f = src.file,
}

-- Source to be used at startup
if tbl.contains(arg, '--dmenu') then 
	M.startup_source = src.dmenu()
else
	M.startup_source = src.apps()
end

-- TODO: Cleanup..
local function add_all_from_source(source, search, list, force)
	local items = source(search, force or false)
	if not items then
		return
	end
	for _, x in ipairs(items) do
		if x ~= nil then
			list:add(ui.list.list_item(x))
		end
	end
end

local cancel = nil
function M.update_list(search, list)
	-- Cancel any existing tasks
	if cancel then
		cancel:cancel()
	end
	cancel = Gio.Cancellable.new()

	-- Check and use bangs if any
	local bang, action = search:match("!(%w+)%s(.*)")
	if bang and #bang > 0 and tbl.key_contains(M.enabled_sources, bang) then
		Gio.Async.start(add_all_from_source, cancel)(M.enabled_sources[bang], action, list, true)
		return
	end

	-- Normally loop through every source
	for _, source in pairs(M.enabled_sources) do
		Gio.Async.start(add_all_from_source, cancel)(source, search, list)
	end
end

return M
