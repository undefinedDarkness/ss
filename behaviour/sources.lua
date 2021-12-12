local tbl = require('libs.tbl')
local str = require('libs.str')
local startup = require('sources').startup
local runtime = require('sources').runtime
local register_item = require('ui.list').register_item
local M = {}

function M.startup()
	local r = {}
	for _, src in ipairs(startup) do
		r = tbl.join(r, src[2]() or {})
	end
	return r
end

local function add_item(i)
	list:add(register_item(i))
end

function M.update(search)
	local bang, action = search:match('!(%w+)%s(.+)')
	local function add_item(i)
		list:add(register_item(i))
	end

	if bang and action then
		for _, src in ipairs(runtime) do
			if str.starts_with(src[1], bang) then
				src[2](add_item, action, true)
			end
		end
	else
		for _, src in ipairs(runtime) do
			src[2](add_item, action, false)
		end
	end
end

return M
