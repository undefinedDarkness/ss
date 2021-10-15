#  Super switcher
A simple quick menu application, built atop gtk in lua.
Heavily inspired by [rofi](https://github.com/davatorium/rofi) and [nvim telescope](https://github.com/nvim-telescope/telescope.nvim), they are great projects that are in a much more finished state
than this mess..

## Customization
You can use the GTK Debugger to get class names and modify their appearance in app.css

### How to use the GTK Debugger
```
GTK_DEBUG=interactive lua init.lua
```

## Modifying functionality
You will need to know lua :) 
There is no customization outside of the source code.
You can search for places you might want to change stuff with `grep -r 'CHANGE' .`

## Installation & Usage
```
git clone https://github.com/undefinedDarkness/ss.git
cd ss
lua init.lua
```

## State of development
I wouldnt consider it usable as of right now..
And its full of performance issues everywhere

### TODO
- Proper capturing of the keyboard
- A file finder source ✔
- A rip grep source
- Fuzzy matching using https://github.com/swarn/fzy-lua
- A unit conversion source
- More advanced results than just icon / text / callback
- A configuration system - Might not implement not sure
`grep -r 'TODO' .`

## Documentation

### 📂 File finder source
Search for files from your home directory,
only works when you use a bang since 
it would be too slow to use normally
Bang: `!f`

### Applications
Search for any installed applications, that were 
installed with a [.desktop](https://wiki.archlinux.org/title/desktop_entries) file.

### Math 
Any queries in the form of `n <operation> n =` will try to be solved by lua,
and the result will become an item,
Bang: `!m`

* Bangs are used as a prefix to your query to target a specific source.
Eg: `!f init.lua` will try using the file finder source
