local M = {}
local Gio = require("lgi").Gio
local str = require("util.str")
local tbl = require("util.tbl")

-- TODO: Im sure there is a lot of code that could be better here
-- especially all the cache bits which might not be needed, im not sure...

-- Find all applications
-- and create items for them
function M.apps()
	local entries = Gio.AppInfo.get_all()
	local o = {}
	for _, entry in ipairs(entries) do
		o[#o + 1] = {
			icon = entry:get_icon(),
			name = entry:get_name(),
			cb = function()
				entry:launch({}, nil, nil)
			end,
		}
	end
	return o
end

-- Read items from stdin and output to stdout
function M.dmenu() 
	local o = {}
	for item in io.lines() do
		table.insert(o, { name = item, cb = function() print(item) end })
	end
	return o
end

local maths_cache = {}
function M.math(search, force)
	if not force then
		-- Check for invalid input
		if (not string.find(search, "=")) or string.find(search, "[a-z][A-Z]") then
			return
		end

		search = search:gsub("=%s*$", "")
	end

	local x = load("return (" .. search .. ")")
	if not x then
		return
	end
	local resp = (search .. " = " .. tostring(x()))
	resp = resp:gsub("  ", " ")

	if not tbl.contains(maths_cache, resp) then
		table.insert(maths_cache, resp)
		return { { name = resp, cb = function() end } }
	else
		return
	end
end

-- TODO: Dont get stuck when someone types *
local home = os.getenv("HOME")
local files_cache = {}
function M.file(search, force)
	if not force then
		return
	end
	local results = io.popen("find " .. home .. ' -name "' .. search .. '"')
	local out = {}
	for line in results:lines() do
		if not tbl.contains(files_cache, line) then -- Do not reapeat entries
			table.insert(files_cache, line)
			table.insert(out, {
				icon = Gio.content_type_get_icon(Gio.content_type_guess(line)),
				name = line:gsub(home, "~"),
				cb = function()
					Gio.AppInfo.launch_default_for_uri_async("file://" .. line)
				end,
			})
		end
	end
	print(require('util.inspect')(out))
	return out
end

return M
