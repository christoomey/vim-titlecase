function! s:titlecase(type, ...) abort
  let g:type = a:type
  let g:it =  a:0
  let g:dem = a:000

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>y"
    let titlecased = substitute(@@, '\<\(\w\)\(\w*\)\>', '\u\1\L\2', 'g')
    silent exe "normal! v`>c" . titlecased
  elseif a:type == 'line'
    '[,']s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g
    " silent exe "normal! '[V']y"
  elseif a:type == 'block'
    " TODO: Implement blockwise mode titlecasing
    " silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
    let titlecased = substitute(@@, '\<\(\w\)\(\w*\)\>', '\u\1\L\2', 'g')
    silent exe "normal! v`]c" . titlecased
  endif
endfunction

xnoremap <silent> <Plug>Titlecase :<C-U> call <SID>titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>Titlecase :<C-U>set opfunc=<SID>titlecase<CR>g@
nnoremap <silent> <Plug>TitlecaseLine :<C-U>set opfunc=<SID>titlecase<Bar>exe 'norm! 'v:count1.'g@_'<CR>

nmap gt <Plug>Titlecase
vmap gt <Plug>Titlecase
nmap gT <Plug>TitlecaseLine
