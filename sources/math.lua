local maths_cache = {}
local tbl = require("util.tbl")
return function(add, search, force)
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
	local resp = (search .. " = " .. x())
	resp = resp:gsub("  ", " ")

	if not tbl.contains(maths_cache, resp) then
		table.insert(maths_cache, resp)
		add({ name = resp, cb = function() end, source = "Maths" })
	else
		return
	end
end
