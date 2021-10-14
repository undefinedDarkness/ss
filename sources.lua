local M = {}
local Gio = require('lgi').Gio
local str = require('str')

function tbl_contains(tbl, v)
	for _, va in ipairs(tbl) do
		if va == v then return true end
	end
	return false
end

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
	if string.find(search, '[a-z][A-Z]') then
		return 
	else
		local x = (load('return ('..search..')'))()
		if x == tonumber(search) then return end
		local r = (search .. ' = ' .. x) 
		if (not tbl_contains(maths_cache, r)) then -- TODO: make this dumb bit better..
			table.insert(maths_cache, r)
			return { name = (search .. ' = ' .. (load('return ('..search..')'))()), cb = function() end } -- add clipboard callback
		else
			return
		end
	end
end

return M
