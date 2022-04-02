local M = {}
local styling = require("platform.styling")
local util = require("platform.util")
local class = styling.class
local fzy = require("platform.fzy")

local categories = {}

-- Load Data From Disk
local function load_categories()
	for line in io.open("emoji/emojis.txt"):lines() do -- TODO Make this not dependent on hard coded path
		local fields = util.split(line, "	")
		local category = fields[2]

		-- Skip skin tones, they slow down the 'people' category so much and break everything
		if category == "Component" or (category == "People & Body" and line:find("skin tone")) then
			goto skip
		end

		if not categories[category] then
			categories[category] = {}
		end
		table.insert(categories[category], { fields[1], fields[4] })
		::skip::
	end
end

-- Before creating the window
function M:_preinit()
	load_categories()
	styling.load_stylesheet("emoji/styles.css")
end

local search = ""
-- The application UI layout
function M:layout()
	self.display = Gtk.FlowBox({
		valign = Gtk.Align.START,
		selection_mode = Gtk.SelectionMode.SINGLE,
		activate_on_single_click = true,
	})

	-- When child is selected
	self.display.on_child_activated = function(_, box)
		require("platform.interaction").clipboard(box:get_child().label)
		require("lgi").GLib.timeout_add_seconds(0, 10, Gtk.main_quit, nil, nil)
		self.window:iconify()
	end

	self.sidebar = Gtk.Box.new(Gtk.Orientation.VERTICAL, 8)
	self.sidebar.homogeneous = false
	class("sidebar", self.sidebar)
	class("emoji-display", self.sidebar)

	self.search = Gtk.SearchEntry()
	self.search.on_search_changed = function(entry)
		search = entry:get_text()
		self.display:invalidate_filter()
	end
	self.search.on_stop_search = function()
		self.window:close()
	end

	ui = Gtk.Box({
		self.sidebar,
		Gtk.Separator(),
		spacing = 0,
		orientation = Gtk.Orientation.HORIZONTAL,
		homogeneous = false,
	})
	ui:pack_start(
		Gtk.Box({
			self.search,
			Gtk.ScrolledWindow({
				self.display,
				vexpand = true,
			}),
			homogeneous = false,
			spacing = 0,
			orientation = Gtk.Orientation.VERTICAL,
		}),
		true,
		true,
		0
	) -- Expand: True, Fill: True, Margin: 0
	class("emoji-display", self.display)
	class("ui", ui)

	self.window:add(ui)
end

local category_icons = {
	["Travel & Places"] = "✈",
	["Smileys & Emotion"] = "🤪",
	["Food & Drink"] = "🌯",
	Flags = "⚑",
	["Animals & Nature"] = "🐅",
	Symbols = "♊",
	Activities = "🏊",
	Objects = "✏",
	["People & Body"] = "🙋",
}

function M:show_category(catname)
	print("Switching to category " .. catname)
	self.display:foreach(Gtk.Widget.destroy) -- Reset container
	print("Clearing Items")
	search = ""
	self.display:get_parent():get_vadjustment():set_value(0.0) -- Scroll up on reset
	for _, v in ipairs(categories[catname]) do
		local label = Gtk.Label({ label = v[1] })
		label:set_tooltip_text(v[2])
		self.display:add(label)
	end
	print("Added new items")
	self.display:show_all()
end

function M:fill()
	local names = require("platform.util").keys(categories)
	table.sort(names)

	for _, k in ipairs(names) do
		local btn = Gtk.Button({
			label = category_icons[k],
			halign = Gtk.Align.START,
		})
		btn.on_clicked = function()
			self:show_category(k)
		end
		self.sidebar:add(btn)
	end

	self:show_category(names[1])

	self.sidebar:show_all()

	self.display:set_filter_func(function(wrapper)
		if #search > 0 then
			local text = wrapper:get_child():get_tooltip_text()
			return fzy.has_match(search, text)
		end
		return true
	end)
end

return M
