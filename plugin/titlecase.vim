if !exists('g:titlecase_map_keys')
  let g:titlecase_map_keys = 1
endif

function! s:titlecase(type, ...) abort
  let g:type = a:type
  let g:it =  a:0
  let g:dem = a:000
  let WORD_PATTERN = '\<\(\k\)\(\k*\)\>'
  let UPCASE_REPLACEMENT = '\u\1\L\2'

  if a:0  " Invoked from Visual mode, use '< and '> marks.
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
    execute '''[,'']s/'.WORD_PATTERN.'/'.UPCASE_REPLACEMENT.'/g' 
  else
    silent exe "normal! `[v`]y"
    let titlecased = substitute(@@, WORD_PATTERN, UPCASE_REPLACEMENT, 'g')
    silent exe "normal! v`]c" . titlecased
  endif
endfunction

xnoremap <silent> <Plug>Titlecase :<C-U> call <SID>titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>Titlecase :<C-U>set opfunc=<SID>titlecase<CR>g@
nnoremap <silent> <Plug>TitlecaseLine :<C-U>set opfunc=<SID>titlecase<Bar>exe 'norm! 'v:count1.'g@_'<CR>

if g:titlecase_map_keys
  nmap gt <Plug>Titlecase
  vmap gt <Plug>Titlecase
  nmap gT <Plug>TitlecaseLine
endif
