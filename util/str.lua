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

function M.title_case(str)
	local out = ""
	for w in str:gmatch("%S+") do
		w = w:lower()
		w = w:sub(1, 1):upper() .. w:sub(2)
		out = out .. " " .. w
	end
	return out
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

-- Path sub library
M.path={}

function M.path.dirname(str)
	if str:match(".-/.-") then
		local name = string.gsub(str, "(.*/)(.*)", "%1")
		return name
	else
		return ''
	end
end

function M.path.basename(str)
	local name = string.gsub(str, "(.*/)(.*)", "%2")
	return name
end

function M.uuid()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

return M
