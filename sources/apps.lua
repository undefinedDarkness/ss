local Gio = require("lgi").Gio
return function()
	local entries = Gio.AppInfo.get_all()
	local o = {}
	for _, entry in ipairs(entries) do
		local desc = entry:get_description()
		o[#o + 1] = {
			icon = entry:get_icon(),
			name = entry:get_name() or '<NO APP NAME>' .. desc and ('\n' .. entry:get_description()) or '',
			cb = function()
				entry:launch({}, nil, nil)
			end,
			-- preview = entry:get_description()
		}
	end
	return o
end
