local home =os.getenv("HOME")
local Gio = require("lgi").Gio
local GdkPixbuf = require("lgi").GdkPixbuf
local str = require('util.str')
local files_cache = {}

local scale_factor = 1.5 -- CHANGE
local function smart_resize_image(og_w, og_h, w, h)
	while (og_w > w and og_h > h) do
		og_w = og_w / scale_factor
		og_h = og_h / scale_factor
	end
	return og_w, og_h
end

local function file_preview(line)
	-- TODO: Handle displaying images
	local ctype = Gio.content_type_guess(line)
	if str.starts_with(ctype, "text") then
		return function()
			local widget = Gtk.TextView {
				editable = false
			}
			local content = require('util.other').read_file(line)
			widget.buffer:set_text(content , #content)
			return widget
		end
	elseif str.starts_with(ctype, "image") then
		return function(parent) 
			local space = parent:get_allocation()
			local pixbuf = GdkPixbuf.Pixbuf.new_from_file(line)
			local og_w = pixbuf:get_width()
			local og_h = pixbuf:get_height()
			local scaling = (og_w <= 256 and og_h <= 256) and GdkPixbuf.InterpType.NEAREST or GdkPixbuf.InterpType.BILINEAR
			local new_w, new_h = smart_resize_image(og_w, og_h, space.width, space.height)
			pixbuf = pixbuf:scale_simple(new_w, new_h, scaling)
			local image = Gtk.Image.new_from_pixbuf(pixbuf)
			image:set_valign(Gtk.Align.CENTER)
			image:set_halign(Gtk.Align.CENTER)
			return image
		end
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
	results:close()
	return out
end 
