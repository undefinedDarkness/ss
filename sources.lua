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
function M.math(search, force)
	if force then goto skip_check end
	-- We only care about numbers and symbols
	if (not string.find(search, '=')) or string.find(search, "[a-z][A-Z]") then return end -- only care about numbers

		search = search:gsub('=', '') -- NOTE: Problems could crop up here...
		::skip_check::
		
		local x = load('return ('..search..')')
		if not x then return end
		local resp = (search .. ' = ' .. tostring(x())) 
	
		if (not tbl.contains(maths_cache, resp)) then -- TODO: make this dumb bit better..
			table.insert(maths_cache, resp)
			return { { name = resp, cb = function() end } } -- TODO: add clipboard callback
		else
			return
		end
end

-- this is too slow to use normally, you have to use a bang to get it...
-- TODO: Icons!
function M.file(search, force)
	if not force then return end
	local results = io.popen('find '..os.getenv('HOME')..' -name "'..search..'"')
	local out = {}
	for line in results:lines() do
		table.insert(out, { name = line, cb = function() end }) -- use xdg-open here..probably
	end
	return out
end

return M
