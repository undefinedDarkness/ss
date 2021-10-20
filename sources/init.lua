return {
	in_file = require("sources.in_file"),
	dmenu = require("sources.dmenu"),
	apps = require("sources.apps"),
	file = require("sources.file"),
	math = require("sources.math"),
}

-- How to create your own source:
-- A source is simply a exported function with 3 arguments
-- func: add, string: search, bool: force
--
-- add can be called to add a item to the list.
-- search is the user's search term.
-- force is true if a bang is used to target the source.
--
-- a item is the following structure:
-- {
--		name - Text representation (required)
--		icon - Icon for the item 
--		widget - Gtk widget (required if icon doesnt exist)
-- }
-- More details: in ui/list.lua
