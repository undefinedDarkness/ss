![screenshot](https://i.ibb.co/s9ckKfG/Screenshot-2021-10-18-144104.png)
#  🚀 SS
A simple quick menu / switcher application, built atop gtk in lua.  
Heavily inspired by [rofi](https://github.com/davatorium/rofi) and [nvim telescope](https://github.com/nvim-telescope/telescope.nvim), they are also great projects 
  
## 🎨 Customization  
You can use the GTK Debugger to get class names and modify their appearance in `app.css`
Useful documents: [GTK CSS Refrence](https://developer-old.gnome.org/gtk3/stable/chap-css-overview.html) & [GTK CSS Supported properties](https://docs.gtk.org/gtk3/css-properties.html)

  
### How to use the GTK Debugger  
```  
GTK_DEBUG=interactive lua init.lua  
```  
  
## Configuration
You will need to know lua :)   
At the moment, There is no customization outside of the source code.  
You can search for places you might want to change stuff with `grep -r 'CHANGE' .`  
  
## Installation & Usage  
You will need gtk, gdk, gio(+ pixbuf), glib installed along with their gir bindings, 
for debian you can install them by installing `gir1.2-gtk-3.0`

You will also need lua (of course), though luajit works fine too.
and the lua-lgi package, they are `lua-lgi lua5.3`

After that, simply do:
```  
git clone https://github.com/undefinedDarkness/ss.git  
cd ss  
lua init.lua  
``` 

Technically SS should just drop into a [awesome](https://awesomewm.org/) configuration (part of why it was made this way), if it doesn't, please make an issue.
  
### TODO  
- Proper capturing of the keyboard - has improved   
- A unit conversion source  
- Combination Source system
- Support functionality like [lighthouse](https://github.com/emgram769/lighthouse)  
- Better documentation  
	syntax highlighting (?) 
- A configuration system (?)
- Improve compatibility with rofi?
- Build the lua fuzzy finding lib natively for better performance.
- Clear non initial items when search entry becomes empty  
`grep -r 'TODO' .` 

<details>
<summary>Done</summary>

- More advanced results than just icon / text / callback ✔  
- Preview support for file finder source   ✔   
	and need image support    ✔  
- Fuzzy matching using https://github.com/swarn/fzy-lua ✔  
- A file finder source ✔  
- A rip grep source  ✔ 
- Dmenu mode  ✔ 
- Add icon support to dmenu mode  ✔  

</details>
  
## Documentation  
  
### 📂 File Finder 
Search for files from your home directory,  
only works when you use a bang since   
it would be too slow to use normally  
Bang: `!f`  
  
### 📦 Applications  
Search for any installed applications, that were   
installed with a [.desktop](https://wiki.archlinux.org/title/desktop_entries) file.  
  
### 👨‍🔬 Math   
Any queries in the form of `n <operation> n =` will try to be solved by lua,  
and the result will become an item,  
Bang: `!m` - The equal sign shouldn't be there when using the bang  
  
### Find in files
Search for content of text files in your home directory,
By default only works with a bang, with a max depth of 2, 
requires [ag](https://github.com/ggreer/the_silver_searcher)
Bang: `!if`

* Bangs are used as a prefix to your query to target a specific source.  
Eg: `!f init.lua` will try using the file finder source  

### Dmenu
Used by calling the script like so:
`printf "Apple\0icon\x1ffolder\nBanana\nOrange" | lua init.lua --dmenu`
* Supports rofi dmenu icon syntax

### Credits  
- [Fzy-Lua](https://github.com/swarn/fzy-lua) for implements fuzzy finding so I don't have to :)  
- [No37](https://github.com/Nooo37) for giving lots of help and feedback on the project  

