local M = {}

function M.starts_with(str, start)
	return #start > 0 and str:sub(1, #start) == start
end

function M.trim(s)
	return s:match("^%s*(.-)%s*$") or ""
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
