local M= {}
local str = require('util.str')
local src = require('sources')
local ui =require('ui')
local tbl = require('util.tbl')

function M.filter_by_search(search, heap, items)
	if str.trim(search) == '' and tbl.contains(items, heap) then
		return true
	elseif #search > 0 and str.starts_with(heap:lower(), search:lower()) then
		return true
	else
		-- print('Rejecting '..heap)
		return false
	end
end

local sources = {src.math,src.file}
-- TODO: Bang!! support
function M.update_list_by_search(search, list)
	for _, source in ipairs(sources) do
		local x = source(search)
		if x ~= nil then 
			list:prepend(ui.list_item(x), -1) end
		end
end

return M
