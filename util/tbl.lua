local M = {}

function M.filter(tbl, fn)
	for k, v in ipairs(tbl) do
		if not fn(k, v) then
			tbl[k] = nil
		end
	end
	return tbl
end

function M.contains(tbl, v, fn)
	for i, val in ipairs(tbl) do
		if (fn and fn(val, v) or val == v) then
			return true, val, i
		end
	end
	return false
end

function M.remove_by_value(t, v)
	for i, val in ipairs(t) do
		if val == v then
			table.remove(t, i)
		end
	end
end

function M.map(tbl, fn)
	local o = {}
	for k, v in ipairs(tbl) do
		o[k] = fn(k, v) or v
	end
	return o
end

return M
