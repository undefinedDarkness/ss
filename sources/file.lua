local Gio = require("lgi").Gio
local GdkPixbuf = require("lgi").GdkPixbuf
local str = require('libs.str')
local files_cache = {}

local scale_factor = 1.5 -- CHANGE to modify image preview size
local function half_resize_image(og_w, og_h, w, h)
	while (og_w > w and og_h > h) do
		og_w = og_w / scale_factor
		og_h = og_h / scale_factor
	end
	return og_w, og_h
end

local function file_preview(line)
	local ctype = Gio.content_type_guess(line)
	if str.starts_with(ctype, "text") then
		return function()
			-- local widget = Gtk.TextView {
			-- 	editable = false,
			-- 	cursor_visible = false
			-- }
			local f = io.open(line)
			local content = f:read("*a")
			f:close()
			-- widget.buffer:set_text(content , #content)
			return Gtk.Label {label=content}
		end
	elseif str.starts_with(ctype, "image") then
		return function(parent) 
			local space = parent:get_allocation()
			local pixbuf = GdkPixbuf.Pixbuf.new_from_file(line)
			local og_w = pixbuf:get_width()
			local og_h = pixbuf:get_height()

			-- Use nearest neighbour scaling for really small images (pixel art)
			local scaling = (og_w <= 256 and og_h <= 256) and GdkPixbuf.InterpType.NEAREST or GdkPixbuf.InterpType.BILINEAR
			
			-- Halve the original width / height till it fits
			local new_w, new_h = half_resize_image(og_w, og_h, space.width, space.height)
			pixbuf = pixbuf:scale_simple(new_w, new_h, scaling)

			local image = Gtk.Image.new_from_pixbuf(pixbuf)
			image:set_valign(Gtk.Align.CENTER)
			image:set_halign(Gtk.Align.CENTER)
			return image
		end
	end
end

local function file_item(line)
	local last = line:gsub(home, '~'):match('[^/]+/[^/]+$') or str.path.basename(last) 
	return {
		source = "File",
		icon = Gio.content_type_get_icon(Gio.content_type_guess(line)),
		name = last..'\n'..line,
		cb = function()
			Gio.AppInfo.launch_default_for_uri("file://"..line)
		end,
		preview = file_preview(line) 
	}
end

return function (add, search, force)
	-- Ignore a search for every file
	if not force or search == "*" then 
		return
	end
	local results = io.popen("find " .. home .. ' -name "' .. search .. '"')
	for line in results:lines() do
		add(file_item(line))
	end
	results:close()
end 
