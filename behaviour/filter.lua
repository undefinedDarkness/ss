local cache = {}
local M = {}
local tbl = require("util.tbl")
local str = require("util.str")
local fzy = require("util.fzy")

function M.fuzzy_search(search, list)
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)

	-- Run all labels through fuzzy finding library
	local data = fzy.filter(
		search,
		tbl.map(cache, function(_, v)
			return v:get_child().id
		end)
	)

	-- Sort in descending order
	table.sort(data, function(a, b)
		return a[3] > b[3]
	end)

	for _, result in ipairs(data) do
		local v = cache[result[1]]
		-- TODO: Highlight matched part
		list:add(v)
	end
end

function M.search(search, list)
	-- Store all new items in the cache & empty the list
	list:foreach(function(child)
		if not tbl.contains(cache, child) then
			table.insert(cache, child)
		end
		list:remove(child)
	end)

	local empty = search:gsub("%s", "") == ""

	-- CHANGE: Remove the :lower() if you want the comparison to be case sensitive
	search = search:lower()

	-- Add each item if they match the search term
	for _, item in ipairs(cache) do
		local heap = item:get_child().id

		if empty or (str.starts_with(heap:lower(), search)) then
			list:add(item)
		end
	end
end

return M
