if !exists('g:titlecase_map_keys')
  let g:titlecase_map_keys = 1
en

fu! SubaWord() 
  return suh(@@, WORD_PATTERN, UPCASE_REPLACEMENT, 'g')
endf

fu! s:titlecase(type, ...) abort
  " help internal-variables
  " this sets global variable type to functionargument type
  " These are passed in just before EOF
  let g:type = a:type
  let g:it =  a:0
  let g:dem = a:000
  "([A-Za-z])([a-zA-Z']*) start keyword
  let WORD_PATTERN = '\<\(\k\)\(\k*''*\k*\)\>'
  let UPCASE_REPLACEMENT = '\u\1\L\2'

  if a:0  " Invoked from Visual mode, use '< and '> marks.
      sil exe "normal! `<" . a:type . "`>y"
    if a:type == ''
      let titlecased = SubaWord()
      call setreg('@', titlecased, 'b')
      sil exe 'normal! ' . a:type . '`>p'
    else
      let @i = SubaWord()
      sil exe 'normal! ' . a:type . '`>"ip'
    en
  elseif a:type == 'line'
    exe '''[,'']s/'.WORD_PATTERN.'/'.UPCASE_REPLACEMENT.'/ge'
  else
    sil exe "normal! `[v`]y"
    let titlecased = SubaWord()
    sil exe "normal! v`]c" . titlecased
  endif
endf


xnoremap <silent> <Plug>Titlecase :<C-U> call <SID>titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>Titlecase :<C-U>set opfunc=<SID>titlecase<CR>g@
nnoremap <silent> <Plug>TitlecaseLine :<C-U>set opfunc=<SID>titlecase<Bar>exe 'norm! 'v:count1.'g@_'<CR>

if g:titlecase_map_keys
  nmap gt <Plug>Titlecase
  vmap gt <Plug>Titlecase
  nmap gT <Plug>TitlecaseLine
endif
