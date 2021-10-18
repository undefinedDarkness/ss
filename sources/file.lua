local home =os.getenv("HOME")
local Gio = require("lgi").Gio
local files_cache = {}

local function file_preview(line)
	-- TODO: Handle displaying images
	return function()
		local widget = Gtk.TextView {
			editable = false
		}
		local content = require('util.other').read_file(line)
		widget.buffer:set_text(content , #content)
		widget:show_all()
		return widget
	end
end

local function file_item(line)
	return {
		icon = Gio.content_type_get_icon(Gio.content_type_guess(line)),
		name = line:gsub(home, "~"),
		cb = function()
			Gio.AppInfo.launch_default_for_uri("file://"..line)
		end,
		preview = file_preview(line) 
	}
end

return function (search, force)
	if not force or search == "*" then -- Ignore a search for every file!
		return
	end
	local results = io.popen("find " .. home .. ' -name "' .. search .. '"')
	local out = {}
	for line in results:lines() do
		-- if not tbl.contains(files_cache, line) then -- Do not repeat entries
			-- table.insert(files_cache, line)
			table.insert(out, file_item(line))
		-- end
	end
	return out
end 
