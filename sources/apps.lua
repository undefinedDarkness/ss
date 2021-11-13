local Gio = require("lgi").Gio
return function()
	local entries = Gio.AppInfo.get_all()
	local o = {}
	for _, entry in ipairs(entries) do
		local desc = entry:get_description()
		local name = entry:get_name()
		if desc then 
			name = name .. "\n" .. desc
		end
		o[#o + 1] = {
			icon = entry:get_icon(),
			source = "Application",
			name = name,
			cb = function()
				entry:launch({}, nil, nil)
			end,
			-- preview = entry:get_description()
		}
	end
	return o
end
