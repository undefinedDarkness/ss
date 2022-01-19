-- Search Library:
-- Fuzzy Finding
-- Regular Searching
local M = {}

local tbl = require("libs.tbl")
local str = require("libs.str")
local ui = require('ui.util')
local state = require('ui.list').state

function M.search(search)
	search = search:lower()
	list:foreach(function(child)
		local name = state[child.id].name:lower()
		if not (str.starts_with(name, search)) then
			child:hide()
		end
	end)
end

return M
