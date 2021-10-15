local M = {}
local Gio = require('lgi').Gio
local str = require('util.str')
local tbl = require('util.tbl')


-- Desktop applications with .desktop files.
function M.apps()
	local entries = Gio.AppInfo.get_all()
	local o = {}
	for _, entry in ipairs(entries) do
		o[#o+1] = {
			icon = entry:get_icon(),
			name = entry:get_name(),
			cb = function() entry:launch({}, nil, nil) end
		}
	end
	return o
end

local maths_cache = {}
function M.math(search)
	-- We only care about numbers and symbols
	if string.find(search, '=') then -- is math operation
		if string.find(search, "[a-z][A-Z]") then return end -- only care about numbers

		search = search:gsub('=', '') -- NOTE: Problems could crop up here...
		
		local x = load('return ('..search..')')
		if not x or x() == tonumber(search) then return end
		
		local resp = (search .. '= ' .. x()) 
		
		if (not tbl.contains(maths_cache, resp)) then -- TODO: make this dumb bit better..
			table.insert(maths_cache, resp)
			return { name = resp, cb = function() end } -- add clipboard callback
		else
			return
		end
	end
end

return M
