" let g:fzf_dir_gitfiles_command = 'GFiles?'
if !exists('g:fzf_dir_gitfiles_command')
	let g:fzf_dir_gitfiles_command = 'GFiles'
endif

if !exists('g:fzf_dir_actions')
	let g:fzf_dir_actions = {
	  \ 'ctrl-t': 'tab split',
	  \ 'ctrl-x': 'split',
	  \ 'ctrl-v': 'vsplit'
	  \ } 
endif

function! s:fzf_dir_sink(directory, val, bang, opts)
	let k = remove(a:val, 0)
	let cmd = get(g:fzf_dir_actions, k, 'edit')
	" echom a:val
	let argument = remove(a:val, 0)
	" echom argument

	if argument == '/'
		let fname = fnamemodify('/', ':p')
	elseif argument == '~/'
		let fname = fnamemodify('~/', ':p')
	elseif argument == '..'
		if a:directory =~ '/$' && a:directory != '/'
			let directory = a:directory[:-2]
		else
			let directory = a:directory
		endif
		let fname = fnamemodify(directory, ':h:p')
	else
		let fname = fnamemodify((a:directory == '/' ? '' : a:directory). '/' . argument, ':p')
		echom fname
		" let fname = fnamemodify(argument, ':p')
	endif
	" echom fname

	" Handle multiple lines in the output

	if argument == "."
		execute cmd a:directory
	elseif isdirectory(fname)
		call s:fzf_dir_worker(a:bang, fname, a:opts)
	else
		" echom fname
		execute cmd fname
	endif
endfunction

function! s:fzf_dir_worker(bang, directory, opts)
	" let a:opts.source = 'cd ' . a:directory . ' && echo -e ".\n/\n~/" && bfind 1'
	" let a:opts.source = 'echo -e ".\n..\n/\n~/" && bfind 1 ' . a:directory
	" echom a:directory
	" let a:opts.source = 'echo -e ".\n..\n/\n~/" && cd "' . a:directory . '" && ls --group-directories-first -Q1 "' . a:directory . '" | xargs -L 1 readlink -f --'
	" let a:opts.source = 'echo -e ".\n..\n/\n~/" && ls --group-directories-first -a "' . a:directory . '"'
	let a:opts.source = 'echo -e "/\n~/" && ls --group-directories-first -a "' . a:directory . '"'
	let directory = a:directory
	let bang = a:bang
	let opts = a:opts
	let a:opts['sink*'] = {val -> s:fzf_dir_sink(a:directory, val, a:bang, a:opts)}
	let prompt = a:directory
	" let prompt = a:directory
	if prompt !~ "/$"
		let prompt = prompt . '/'
	endif
	if !has_key(a:opts, 'options')
		let a:opts.options = []
	elseif type(a:opts.options) == type('')
		let a:opts.options = [a:opts.options]
	endif
	" echom a:opts.options
	" echom prompt
	let l:i = index(a:opts.options, '--prompt')
	if (l:i >= 0)
		call remove(a:opts.options, l:i)
		call remove(a:opts.options, l:i)
	endif
	call add(a:opts.options, '--prompt')
	call add(a:opts.options, prompt)
	" echom a:opts.options
	" echom map(a:opts.options, 'v:val =~ "--expect"')
	let l:i = index(map(copy(a:opts.options), 'v:val =~ "--expect"'), 1)
	if (l:i >= 0)
		call remove(a:opts.options, l:i)
	endif
	call add(a:opts.options, '--expect=' . join(keys(g:fzf_dir_actions), ','))
	" echom a:opts.options
	" echom a:opts
	call fzf#run(fzf#wrap('FzfDir', fzf#vim#with_preview(a:opts), a:bang))
	" call fzf#run(a:opts)
endfunction

function! fzf_dir#dir#fzf_directory(force_regular, bang, ...)
	let git_project_folder = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
	if len(a:1) >= 1
		let directory = fnamemodify(a:1, ':p')
	else
		let directory = len(git_project_folder) == 0 ? getcwd() : git_project_folder
	endif
	if !a:force_regular && len(a:1) == 0 && len(git_project_folder) > 0
		" call fzf#vim#gitfiles(a:bang)
		if g:fzf_dir_gitfiles_command == 'GFiles?'
			execute 'GFiles' . (a:bang ? '!' : '') . '?'
		else
			execute g:fzf_dir_gitfiles_command . (a:bang ? '!' : '')
		endif
	else
		let opts = {}
		" let folder = '/data'
		call s:fzf_dir_worker(a:bang, directory, opts)
	endif
endfunction


