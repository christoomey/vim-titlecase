nnoremap <silent> <Plug>Titlecase
      \ :<C-U>set opfunc=titlecase#titlecase<CR>g@
xnoremap <silent> <Plug>Titlecase
      \ :<C-U> call titlecase#titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>TitlecaseLine
      \ :<C-U>set opfunc=titlecase#titlecase<Bar>exe 'normal! ' . v:count1 . 'g@_'<CR>

if !hasmapto('<Plug>Titlecase', 'n') && maparg('gz', 'n') ==# ''
  nmap gz <Plug>Titlecase
endif
if !hasmapto('<Plug>Titlecase', 'x') && maparg('gz', 'x') ==# ''
  xmap gz <Plug>Titlecase
endif
if !hasmapto('<Plug>TitlecaseLine', 'n') && maparg('gzz', 'n') ==# ''
  nmap gzz <Plug>TitlecaseLine
endif
