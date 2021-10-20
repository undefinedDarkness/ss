local Gio = require("lgi").Gio
return function()
	local o = {}
	for item in io.lines() do
		local icon = item:match("\0icon\x1f(.*)") -- Be compatible with rofi's format
		table.insert(o, {
			icon = icon and Gio.ThemedIcon.new(icon) or nil,
			name = item,
			cb = function()
				print(item)
			end,
		})
	end
	return o
end
