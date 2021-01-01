command! -nargs=? -complete=dir -bang FzfDirGit call fzf_dir#dir#fzf_directory(0, <bang>0, <q-args>)
command! -nargs=? -complete=dir -bang FzfDir call fzf_dir#dir#fzf_directory(1, <bang>0, <q-args>)
