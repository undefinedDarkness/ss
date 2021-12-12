-- Search Library:
-- Fuzzy Finding
-- Regular Searching

local cache = {}
local M = {}
local tbl = require("libs.tbl")
local str = require("libs.str")
local fzy = require("libs.fzy")

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
			return v.id
		end)
	)

	-- Sort in descending order
	table.sort(data, function(a, b)
		return a[3] > b[3]
	end)

	for _, result in ipairs(data) do
		local v = cache[result[1]]
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
		local heap = item.id

		if empty or (str.starts_with(heap:lower(), search)) then
			list:add(item)
		end
	end
end

return M
