local M = {}

function M.contains(tbl, v)
	for _, val in ipairs(tbl) do
		if val == v then return true end
	end
	return false
end

function M.all(tbl)
	for _, val in ipairs(tbl) do
		if val == false or val == nil then
			return false
		end
	end
	return true
end

return M
