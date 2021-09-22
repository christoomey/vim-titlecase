let s:titlecase_excluded_words = get(g:, 'titlecase_excluded_words', [])
let s:local_exclusion_list = deepcopy(s:titlecase_excluded_words)
call map(s:local_exclusion_list, 'tolower(v:val)')

function! s:capitalize(string)
  " Don't change intentional all caps
  if(toupper(a:string) ==# a:string)
    return a:string
  endif

  let s = tolower(a:string)

  let exclusions = '^\(a\|an\|and\|as\|at\|but\|by\|en\|for\|if\|in\|nor\|of\|on\|or\|per\|the\|to\|v.?\|vs.?\|via\)$'
  " Return the lowered string if it matches either the built-in or user exclusion list
  if (match(s, exclusions) >= 0) || (index(s:local_exclusion_list, s) >= 0)
    return s
  endif

  return toupper(s[0]) . s[1:]
endfunction

function! titlecase#titlecase(type, ...) abort
  let WORD_PATTERN = '\<\(\k\)\(\k*''*\k*\)\>'
  " calls s:capitalize with the whole pattern match
  let UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'

  let regbak = @@
  try
    if a:0  " Invoked from Visual mode, use '< and '> marks.
      " Back up unnamed register to avoid clobbering its contents
      if a:type == ''
        silent exe "normal! `<" . a:type . "`>y"
        let titlecased = substitute(@@, WORD_PATTERN, UPCASE_REPLACEMENT, 'g')
        call setreg('@', titlecased, 'b')
        silent execute 'normal! ' . a:type . '`>p'
      else
        silent exe "normal! `<" . a:type . "`>y"
        let @i = substitute(@@, WORD_PATTERN, UPCASE_REPLACEMENT, 'g')
        silent execute 'normal! ' . a:type . '`>"ip'
      endif
    elseif a:type == 'line'
      execute '''[,'']s/'.WORD_PATTERN.'/'.UPCASE_REPLACEMENT.'/ge'
      " Always capitalize the start and end
      execute '''[,'']s/'.WORD_PATTERN.'/\u\1\L\2/e'
      execute '''[,'']s/'.WORD_PATTERN.'\(\K*\)$/\u\1\L\2\e\3/e'
    else
      silent exe "normal! `[v`]y"
      let titlecased = substitute(@@, WORD_PATTERN, UPCASE_REPLACEMENT, 'g')
      silent exe "normal! v`]c" . titlecased
    endif
  finally
    " Restore unnamed register to its original state
    let @@ = regbak
  endtry
endfunction
