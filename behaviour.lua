local M = {}
local str = require("util.str")
local ui = require("ui")
local tbl = require("util.tbl")
local Gio = require("lgi").Gio

local cache = {}
function M.filter_by_fuzzy_search(list, search)
	local fzy = require("util.fzy")
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)

	local data = fzy.filter(
		search,
		tbl.map(cache, function(_, v)
			return v:get_child().label
		end)
	)
	table.sort(data, function(a, b)
		return a[3] > b[3]
	end)
	for _, result in ipairs(data) do
		local v = cache[result[1]]
		list:add(v)
	end
end

function M.filter_by_search(list, search)
	-- Store all new items in the cache & empty the list
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)
	-- Add each item if they match the search term
	for _, item in ipairs(cache) do
		local heap = item:get_child().label
		-- CHANGE: Remove the :lower() if you want the comparison to be case sensitive
		if search == "" or #search > 0 and str.starts_with(heap:lower(), search:lower()) then
			list:add(item)
		end
	end
end

local src = require("sources")

-- CHANGE this to modify active sources, and the bangs used for each source
-- TODO: Support a full form of a bang
local sources = {
	m = src.math,
	f = src.file,
}

-- TODO: Cleanup..
local function add_all_from_source(source, search, list, force)
	local items = source(search, force or false)
	if not items then
		return
	end
	for _, x in ipairs(items) do
		if x ~= nil then
			list:add(ui.list_item(x))
		end
	end
end

local cancel = nil
function M.update_list_by_search(search, list)
	-- Cancel any existing tasks
	if cancel then
		cancel:cancel()
	end
	cancel = Gio.Cancellable.new()

	-- Check and use bangs if any
	local bang, action = search:match("!(%w+)%s(.*)")
	if bang and #bang > 0 and tbl.key_contains(sources, bang) then
		Gio.Async.start(add_all_from_source, cancel)(sources[bang], action, list, true)
		return
	end

	-- Normally loop through every source
	for _, source in pairs(sources) do
		Gio.Async.start(add_all_from_source, cancel)(source, search, list)
	end
end

return M
