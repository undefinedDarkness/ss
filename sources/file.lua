local home =os.getenv("HOME")
local Gio = require("lgi").Gio
local files_cache = {}
return function (search, force)
	if not force or search == "*" then -- Ignore a search for every file!
		return
	end
	local results = io.popen("find " .. home .. ' -name "' .. search .. '"')
	local out = {}
	for line in results:lines() do
		if not tbl.contains(files_cache, line) then -- Do not reapeat entries
			table.insert(files_cache, line)
			table.insert(out, {
				icon = Gio.content_type_get_icon(Gio.content_type_guess(line)),
				name = line:gsub(home, "~"),
				cb = function()
					Gio.AppInfo.launch_default_for_uri("file://"..line)
				end,
			})
		end
	end
	return out
end 
