-- Argument Parsing

local tbl = require("libs.tbl")
local str = require("libs.str")
local M = {}

M.arguments = {
	theme = "default",
	type = "center-menu"
}

for idx, a in ipairs(arg) do
	if str.starts_with(a, "--") then
		M.arguments[a:sub(3):gsub('-', '_')] = arg[idx+1] or true
	end
end

if M.arguments.help then
	print([[

Super Searcher
--------------
--dmenu	      -> Launch in dmenu mode
--style       -> Change css file that is loaded (filename)
--no-switcher -> Disable switcher
--type        -> Window type
	]])
	os.exit()
end

return M.arguments
