local M = {}

function M.highlight_section(whole, match_start, match_end)
	return whole:sub(1, match_start) .. '<b>' .. whole:sub(match_start+1, match_end-1) .. '</b>' .. whole:sub(match_end)
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
	return input:sub(1, f - 1), input:sub(f + 1, #input)
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

function M.uuid()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

return M
