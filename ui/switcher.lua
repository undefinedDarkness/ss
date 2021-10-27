local enabled = require("behaviour.sources").enabled_sources
local class = require("ui.util").class

local list = Gtk.VBox{homogeneous = false}
class(list, "mode-switcher")

for _, source in ipairs(enabled) do
	local btn = Gtk.CheckButton {
		Gtk.Label { label = source.full_form },
		active = true
	}
	function btn.on_toggled()
		if not btn.active then
			print("Disabling source:", source.full_form)
			require('behaviour.sources').disable_source(source)
		elseif btn.active then
			print("Enabling source:", source.full_form)
			require('behaviour.sources').enable_source(source)
		end
	end
	class(btn, "mode-button")

	list:pack_start(btn, false, false, 0)
end

return list
