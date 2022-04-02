local M = {
	split = function(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
			table.insert(t, str)
		end
		return t
	end,

	dbg = function(str)
		print("")

		for k, v in pairs(str) do
			print(k, v)
		end

		for k, v in ipairs(str) do
			print(k, v)
		end

		print("")
	end,

	merge = function(old, new)
		for k, v in pairs(new) do
			old[k] = v
		end
		return old
	end,

	keys = function(tbl)
		local ks = {}
		for k, _ in pairs(tbl) do
			ks[#ks + 1] = k
		end
		return ks
	end,

    cmd = function(cmd)
      return io.popen(cmd):read('a'):gsub('[\n\r]*$', '')
    end
}
    
    M.src_path = function()
      return M.cmd("realpath " .. debug.getinfo(1, "S").source:sub(2)):gsub("/platform/util.lua", "")
    end
    
M.parse_arguments = function(arguments)
		local o = {}
		for _, arg in ipairs(arguments) do
			local key, value = arg:match("(%S+)=(%S+)")
			if key and value then
				o[key] = value
			elseif arg:find("^--") then
				o[arg:sub(3)] = true
			end
		end
		return o
	end

return M
