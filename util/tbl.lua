local M = {}

function M.filter(tbl, fn)
	for k, v in ipairs(tbl) do
		if not fn(k, v) then
			tbl[k] = nil
		end
	end
	return tbl
end

function M.contains(tbl, v)
	for _, val in ipairs(tbl) do
		if val == v then
			return true
		end
	end
	return false
end

function M.key_contains(tbl, v)
	for key, _ in pairs(tbl) do
		if key == v then
			return true
		end
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

function M.map(tbl, fn)
	local o = {}
	for k, v in ipairs(tbl) do
		o[k] = fn(k, v) or v
	end
	return o
end

return M
