return {
  clipboard = function(text)
    local clip = Gtk.Clipboard.get_default(Gdk.Display.get_default())
    clip:set_text(text, -1)
    clip:store()
  end
}
