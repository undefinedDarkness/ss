local Gio = require("lgi").Gio

return function()
	local entries = Gio.AppInfo.get_all()
	local o = {}
	
	local default = Gtk.IconTheme.get_default()
	local function lookup(name)
		if name then
			local l = default:lookup_icon(name, 32, {})
			if l then
				return l:load_icon()
			end
		end
	end
	local fallback = lookup('applications-all')

	for _, entry in ipairs(entries) do
		local name = entry:get_name()
		if name == "UXTerm" then
			goto continue
		end
		local icon = entry:get_icon() or lookup(entry:get_executable()) -- or fallback

		if icon then
			o[#o + 1] = {
				icon = icon,
				source = "Application",
				name = name,
				desc = entry:get_description(),
				cb = function()
					entry:launch()
				end,
			}
		end
		::continue::
	end
	return o
end
