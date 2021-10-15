local M= {}
local str = require('util.str')
local src = require('sources')
local ui =require('ui')
local tbl = require('util.tbl')

local cache = {}
function M.filter_by_search(list, search)
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)
	for _, item in ipairs(cache) do
		local heap = item.label
		if search == "" or #search > 0 and str.starts_with(heap:lower(), search:lower()) then
			list:add(item) 
		end
	end
end

-- CHANGE
-- Bang - Source fn
-- TODO: Support a full form of a bang
local sources = { 
	m = src.math,
	f = src.file
}
-- TODO: Bang!! support
-- TODO: Cleanup..
function M.update_list_by_search(search, list)
	local bang, action = search:match("!(%w+)%s(.*)")
	if bang and #bang > 0 and tbl.key_contains(sources, bang) then
		local items = sources[bang](action, true) -- TODO: support multiple return elements...
		if not items then return end
		for _, x in ipairs(items) do
			if x ~= nil then 
				list:add(ui.list_item(x)) 
			end
		end
		return
	end
	for _, source in pairs(sources) do
		local items = source(search, false)
		if not items then goto skip end
		for _, x in ipairs(items) do
			if x ~= nil then 
				list:add(ui.list_item(x)) 
			end
		end
		::skip::
	end
end

return M
