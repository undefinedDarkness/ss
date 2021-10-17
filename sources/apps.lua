local Gio = require("lgi").Gio
return function () 
	local entries = Gio.AppInfo.get_all()
	local o = {}
	for _, entry in ipairs(entries) do
		o[#o + 1] = {
			icon = entry:get_icon(),
			name = entry:get_name(),
			cb = function()
				entry:launch({}, nil, nil)
			end,
		}
	end
	return o
end
