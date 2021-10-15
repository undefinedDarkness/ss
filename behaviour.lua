local M= {}
local str = require('util.str')
local src = require('sources')
local ui =require('ui')
local tbl = require('util.tbl')

function M.filter_by_search(list, search, items)
	list:foreach(function(child)
		local heap = child.label
		if not ((str.trim(search) == '' and tbl.contains(items, heap)) or (#search > 0 and str.starts_with(heap:lower(), search:lower()))) then
			child:destroy()
		end
	end)
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
