local tbl = require("util.tbl")
local str = require("util.str")
local M = {}

-- Parse arguments {{{
M.arguments = {
	style = "app.css"
}

for idx, a in ipairs(arg) do
	if str.starts_with(a, "--") then
		M.arguments[a:sub(3)] = arg[idx+1] or true
	end
end

if M.arguments.help then
	print([[

Super Searcher
--------------

--dmenu	-> Launch in dmenu mode
--style -> Change css file that is loaded (filename)
	]])
	os.exit()
end

return M
