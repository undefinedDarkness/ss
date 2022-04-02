local M = {}

function M._preinit()
  
end

function M:window()
  self.window = Gtk.Window {
    title = "Swicher",
    window_position = Gtk.WindowPosition.CENTER,
    default_width = 350,
    decorated = false,
    -- type = Gtk.WindowType.POPUP,
    type_hint = Gdk.WindowTypeHint.DIALOG,
    default_height = 200
  }
  self.window.on_destroy = Gtk.main_quit
end

function M:layout()
  self.window:add(Gtk.Label { label = "Hello World" })
end

function M:attach()

  if Gtk.Widget:is_type_of(self.display) and type(self.fill) == "function" then
    self.display.on_show = function() self:fill() end
  end

end

function M:_loop()
  self.window:show_all()
  Gtk.main()
end

return M
