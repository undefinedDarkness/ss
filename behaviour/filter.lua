local cache = {}
local M = {}
local tbl = require('util.tbl')
local str = require('util.str')

function M.fuzzy_search(list, search)
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
			print(':',v:get_child().id)
			return v:get_child().id--.label
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

function M.search(list, search)
	-- Store all new items in the cache & empty the list
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)
	-- Add each item if they match the search term
	for _, item in ipairs(cache) do
		local heap = item:get_child().id
		-- CHANGE: Remove the :lower() if you want the comparison to be case sensitive
		if search == "" or #search > 0 and str.starts_with(heap:lower(), search:lower()) then
			list:add(item)
		end
	end
end

return M
