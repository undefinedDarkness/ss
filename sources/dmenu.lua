return function () 
	local o = {}
	for item in io.lines() do
		table.insert(o, { name = item, cb = function() print(item) end })
	end
	return o
end
