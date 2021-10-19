local str= require('util.str')
local home = os.getenv("HOME")
return function (search, force)
	if (not force) or (#search == 0) then -- Ignore a search for every file!
		return
	end

	-- Collect output lines
	-- CHANGE to use a different program to search
	local cmd = io.popen("ag -H -F --depth 2 "..search..' '..home) 
	-- The depth is set to make the search decently fast...
	local lines = {}
	for line in cmd:lines() do
		table.insert(lines, line)
	end
	cmd:close()

	local out = {}
	local current = nil
	local index = 0
	while (index < #lines) do
		index = index + 1
		-- Create new widget and add file name...
		if not current then
			-- Note: Using an image here, breaks everything for some reason 	
			current = Gtk.VBox {
				require('ui.util').class(Gtk.Label { 
					label = lines[index],
					xalign = 0,
				}, 'file-title')
			}
		-- END
		elseif lines[index] == "" then
			table.insert(out, { widget = current, name = str.uuid() })
			current = nil
		else
			-- Add line and line number
			current:add(Gtk.Label { label = '		'..str.trim(lines[index]), xalign = 0 })
		end
	end

	return out
end 
