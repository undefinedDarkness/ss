local M = {}

function M.parse_search_arguments(search, expected)
	local cpy = search
	for match in search:gmatch('\w+:\S+') do
		local name, val = M.split_between(search, expected)
		expected[name:lower()] = val
		cpy = cpy:gsub(search, '')
	end 
	return expected, cpy
end

function M.starts_with(str, start)
	return #start > 0 and str:sub(1, #start) == start
end

function M.trim(s)
	return s:match("^%s*(.-)%s*$") or ""
end

-- Only useful for single char splitting
function M.split_between(input, sep)
	local f = string.find(input, sep)
	return input:sub(1, f-1), input:sub(f+1, #input)
end

function M.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

return M
