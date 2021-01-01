# TODO
* [x] Write source that adds '.' (might already be there), '/', and '~/' to the listed files
* [x] Write sink that handles '.' via netrw
	* Just comes down to handling '.' like a file, not like a folder
* [x] Fix handling of optional argument for directory
* [x] Fix `..` after first call
* [x] Fix e binding
* [x] Add handling for additional commands, `s:common_sink` should point me there (but can probably be simplified)
	* Got it. Was a bit tricky because I didn't realize at first that I needed `sink*` in the `opts` array.
* [x] Add handling for git folders, that is, point to project folder instead of current file folder and use higher depth. Might be automatic if I use the current folder, who knows
* [WONT] Add global `max_depth` parameter.
	* not worth it, don't do it.
* [x] Add preview
* [x] Fix bug that leads us to show `//data` instead of `/data`
	* Just added manual handling for `/` for now
