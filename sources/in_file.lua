local str = require("util.str")
local home = os.getenv("HOME")
local Gio = require("lgi").Gio
return function(add, search, force)
	if not force or (#search == 0) then -- Ignore a search for every file!
		return
	end

	-- Collect output lines
	-- CHANGE to use a different program to search
	-- The depth is set to make the search decently fast.
	-- TODO: Maybe switch to grep or rg for a default...
	local cmd = io.popen("ag -H -F --depth 2 " .. search .. " " .. home)
	local lines = {}
	for line in cmd:lines() do
		table.insert(lines, line)
	end
	cmd:close()

	local current = nil
	local index = 0
	while index < #lines do
		index = index + 1
		-- Create new widget and add file name...
		if not current then
			-- Note: Using an image here, breaks everything for some reason
			local icon = Gtk.Image.new_from_gicon(
				Gio.content_type_get_icon(Gio.content_type_guess(lines[index])),
				Gtk.IconSize.DND
			)
			icon:set_pixel_size(32)

			local title = Gtk.HBox({ homogeneous = false, spacing = 8 })
			title:pack_start(icon, false, false, 0)
			title:pack_start(
				require("ui.util").class(
					Gtk.Label({
						label = lines[index]:gsub(home, "~"),
						xalign = 0,
					}),
					"file-title"
				),
				false,
				false,
				0
			)

			current = Gtk.VBox({
				title,
			})

			-- End current item
		elseif lines[index] == "" then
			add({
				widget = current,
				name = str.uuid(),
				cb = function()
					Gio.AppInfo.launch_default_for_uri("file://" .. line)
				end,
			})
			current = nil
		else
			-- Add line with slight margin
			local num, line = lines[index]:match("(%d+):(.*)")
			current:add(Gtk.Label({
				label = num .. ":		" .. str.trim(line),
				xalign = 0,
			}))
		end
	end

end
