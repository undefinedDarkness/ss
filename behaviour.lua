local M= {}
local str = require('str')
local src = require('sources')
local ui =require('ui')

function M.filter_by_search(search, heap)
	if str.trim(search) == '' or str.i_starts_with(heap, search) then
		return true
	end
	return false
end

local sources = {src.math}
function M.update_list_by_search(search, list)
	for _, source in ipairs(sources) do
		local x = source(search)
		if x ~= nil then 
			list:add(ui.list_item(x)) end
		end
end

return M
