"Dan's FileTypes

augroup filetypes
    au!

    au BufNewFile,BufRead .conkyrc               set syntax=conkyrc 
    au BufNewFile,BufRead *.yaml                 set tabstop=2 shiftwidth=2

    au BufNewFile,BufRead .aliases               set syntax=sh
    au BufNewFile,BufRead .history               set syntax=sh
    au BufNewFile,BufRead .mailrc                set syntax=sh
    au BufNewFile,BufRead .shrc                  set syntax=sh

    au BufNewFile,BufRead .cshrc                 set syntax=tcsh

    au BufNewFile,BufRead .python_history        set syntax=python



augroup END

