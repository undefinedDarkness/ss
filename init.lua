Gtk = require('lgi').require('Gtk', '3.0')
Gdk = require('lgi').Gdk

local default = require('platform.base')
local util = require('platform.util')

local args = util.parse_arguments(arg)
for k,v in pairs(args) do
  print(k,v)
end

local mod = require(args.module or 'emoji')

local exe = util.merge(default, mod)

exe:_preinit()
exe:window()

exe:layout()
exe:attach()

exe:_loop()
