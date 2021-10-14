local M = {}

function M.starts_with(str, start)
   return str:sub(1, #start) == start
end

-- TODO: Figure out a better way for case insensitivity!
function M.i_starts_with(x,y)
	return M.starts_with(x:lower(), y:lower())
end

function M.trim(s)
	return s:match "^%s*(.-)%s*$"
end

function M.match(string, pat)
	for w in pat:gmatch('.') do
		if w == string then
			return true
		end
	end
	return false
end

function M.split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

return M
