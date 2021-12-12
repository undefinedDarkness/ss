-- NAME, FUNCTION, STARTUP?
return {
	runtime = {
		{ "file",  require("sources.file" ) },
	},
	startup = {
		{ "dmenu", require("sources.dmenu") },
		{ "apps",  require("sources.apps" ) }
	}
}
