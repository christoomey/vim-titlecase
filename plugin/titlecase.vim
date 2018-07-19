if !exists('g:titlecase_map_keys')
  let g:titlecase_map_keys = 1
en
fu! SubaWord() 
" some optional non-word chars, followed by a word, (grab first letter), (rest of letters)
  let s:updated = substitute(@@, s:WORD_PATTERN, s:UPCASE_REPLACE, 'ge')
  return s:updated
endf
fu! CapAfterHyphen()
  let s:updated = substitute(s:updated, s:BEFORE_HYPHEN,  s:HYPHEN_REPLACE, 'ge')
  let s:updated = substitute(s:updated, s:AFTER_HYPHEN,  s:HYPHEN_REPLACE, 'ge')
  return s:updated 
endf
fu! Shrinkifier() "shrink words < 3 letters
  "return substitute(@@, '\<\(\a\{,3}\)\>', s:SMALL_REPLACE, 'ge')
  let s:updated = substitute(s:updated, s:SMALL_WORD, s:SMALL_REPLACE, 'ge')
  return s:updated
endf
fu! CapitalPronouns() 
  "I + it + ' + suffix
    "let s:updated = substitute(@@, '<([iI])(''ve|''d|''ll|''m|t''d|t''l|t''s|t)>' , PRONOUN_REPLACE, 'g') 
    let s:updated = substitute(s:updated, s:PRONOUN_I_IT, s:PRONOUN_REPLACE, 'ge') 
    "similar substitution for other pronouns
    let s:updated = substitute(s:updated, s:PRONOUN_YOU, s:PRONOUN_REPLACE, 'ge') 
    let s:updated = substitute(s:updated, s:PRONOUN_HE, s:PRONOUN_REPLACE, 'ge')
    let s:updated = substitute(s:updated, s:PRONOUN_SHE, s:PRONOUN_REPLACE, 'ge')
    let s:updated = substitute(s:updated, s:PRONOUN_WE, s:PRONOUN_REPLACE, 'ge')
    let s:updated = substitute(s:updated, s:PRONOUN_THEY, s:PRONOUN_REPLACE, 'ge')
   " aren't    don't    isn't    wasn't    can't    weren't    weren't    wouldn't    doesn't    hasn't    haven't    couldn't
    let s:updated = substitute(s:updated, s:PRONOUN_NOT, replaceme, 'ge')
    " Demonstrative pronouns - those, this, these, that
    return s:updated
endf

fu! SmallApostrophes() "in case it's shrunk by shrinkifier
    let s:updated = substitute(s:updated, RECAP_FIRST, RECAP_REPLACE, 'e')
    return s:updated
endf

fu! RecapFirst() "in case it's shrunk by shrinkifier
    "'^W{-}(\w)([-''A-Za-z]{-}\s)'
    "return substitute(@@, '^W{-}(\w)([-''A-Za-z]{-}\s)', '\u\1\2', 'ge')
    let s:updated = substitute(s:updated, SHORT_CONTRACTION, PRONOUN_REPLACE, 'g')
    return s:updated
endf

fu! SmallApostrophes()
  "return substitute(@@, '<(\a['']\a{,1})', s:SMALL_REPLACE)
  let s:updated = substitute(s:updated, '\v<(\a['']\a{,1})', s:SMALL_REPLACE)
  echo 'SmallApostrophes is ' . s:updated
  return s:updated
endf

fu! NormalCmd(suffix)
  sil exe 'normal! ' . g:type . a:suffix
endf

fu! DoSubstitutions() 
  " get first word
  let s:updated = SubaWord()
  let s:updated = Shrinkifier()
  let s:updated = CapAfterHyphen()
  let s:updated = CapitalPronouns()
  let s:updated = SmallApostrophes()
  let s:updated = RecapFirst()
  return s:updated
endf

fu! s:titlecase(type, ...) abort
  let g:type = a:type
  let g:it =  a:0
  let g:dem = a:000

  let s:WORD_PATTERN = '<(\k)(\k*''*\k*)>'
  let s:UPCASE_REPLACE = '\u\1\L\2'
  let s:SMALL_WORD = '\v<(\a{,3})>'
  let s:SMALL_WORD_REPLACE = '\L\1'
  let s:BEFORE_HYPHEN = '\v(\w)(\w{-}-)'
  let s:AFTER_HYPHEN = '\v(-\w)(\w{-}[ -])'
  let s:HYPHEN_REPLACE = '\u\1\L\2'
  let s:PRONOUN_REPLACE = '\u\1\L\2'
  let s:PRONOUN_I_IT = '\v<([iI])(''ve|''d|''ll|''m|t''d|t''l|t''s|ts|t)>'
  let s:PRONOUN_YOU = '\v<([yY])(ou''ve|ou''d|ou''ll|ou''re|our|ou)>'
  let s:PRONOUN_HE = '\v<([hH])(e''d|e''ll|e''s|e)>'
  let s:PRONOUN_SHE = '\v<([sS])(he''d|he''ll|he''s|he)>'
  let s:PRONOUN_WE = '\v<([wW])(e''d|e''ll|e''re|ho''s|ho''d|ho''|e)>'
  let s:PRONOUN_THEY = '\v<([tT])(hey''d|hey''ll|hey''re|his|hose|hese|hat|hey)>'
  let s:PRONOUN_NOT = '\v<(\a)(\a{-}''t)>'
  let s:SHORT_CONTRACTION = '\v<(\a{,3})(''\a*)>'
  let s:RECAP_FIRST = '\v^W{-}<(\w)([-''A-Za-z]{-})>'
  let s:RECAP_REPLACE = '\u\1\e\2'

  if a:0  " Invoked from Visual mode, use '< and '> marks.
      sil exe "normal! `<" . a:type . "`>y"
    if a:type == ''
      let titlecased = DoSubstitutions()
      call setreg('@', titlecased, 'b')
      call NormalCmd('`>p')
      " sil exe 'normal! ' . a:type . '`>p'
    else
      let @i = DoSubstitutions()
      " sil exe 'normal! ' . a:type . '`>"ip'
      call NormalCmd('`>"ip')
  en
  elseif a:type == 'line'
    exe '''[,'']s/'.s:WORD_PATTERN.'/'.s:UPCASE_REPLACE.'/ge'
    exe '''[,'']s/'.s:SMALL_WORD.'/'.s:SMALL_WORD_REPLACE.'/ge'
    exe '''[,'']s/'.s:BEFORE_HYPHEN .'/'.s:HYPHEN_REPLACE.'/ge'
    exe '''[,'']s/'.s:AFTER_HYPHEN .'/'.s:HYPHEN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_I_IT.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_YOU.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_HE.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_SHE.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_WE.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_THEY.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:PRONOUN_NOT.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:SHORT_CONTRACTION.'/'.s:PRONOUN_REPLACE.'/ge'
    exe '''[,'']s/'.s:RECAP_FIRST.'/'.s:RECAP_REPLACE.'/e'
  else
    sil exe "normal! `[v`]y"
    let titlecased = DoSubstitutions()
    sil exe "normal! v`]c" . titlecased
  endif
endf

xnoremap <silent> <Plug>Titlecase :<C-U> call <SID>titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
" waits for a motion e.g. gt5w does this over 5 words
nnoremap <silent> <Plug>Titlecase :<C-U>set opfunc=<SID>titlecase<CR>g@
"defaults to 1 line (that's what v:count1) does
nnoremap <silent> <Plug>TitlecaseLine :<C-U>set opfunc=<SID>titlecase<Bar>exe 'norm! 'v:count1.'g@_'<CR>

if g:titlecase_map_keys
  nmap gt <Plug>Titlecase
  vmap gt <Plug>Titlecase
  vmap gT <Plug>Titlecase
  nmap gT <Plug>TitlecaseLine
endif
