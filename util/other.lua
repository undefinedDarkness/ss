local M = {}

function M.parse_search_arguments(search, expected)
	local cpy = search
	for match in search:gmatch("%w+:%S+") do
		local name, val = require("util.str").split_between(search, expected)
		expected[name:lower()] = val
		cpy = cpy:gsub(search, "")
	end
	return expected, cpy
end

function M.read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

return M
