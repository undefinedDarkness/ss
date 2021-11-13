return {
	{ bang = "m", full_form = "math", require("sources.math") },
	{ bang = "f", full_form = "file", require("sources.file") },
	{ bang = "if",  full_form = "infile", require("sources.in_file") },
	dmenu = require("sources.dmenu"),
	apps = require("sources.apps"),
}
