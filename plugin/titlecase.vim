nnoremap <silent> <Plug>Titlecase
      \ :<C-U>set opfunc=titlecase#titlecase<CR>g@
xnoremap <silent> <Plug>Titlecase
      \ :<C-U> call titlecase#titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>TitlecaseLine
      \ :<C-U>set opfunc=titlecase#titlecase<Bar>exe 'normal! ' . v:count1 . 'g@_'<CR>

let s:titlecase_map_keys = get(g:, 'titlecase_map_keys', 1)
if s:titlecase_map_keys
  if !hasmapto('<Plug>Titlecase', 'n') && maparg('gt', 'n') ==# ''
    nmap gt <Plug>Titlecase
  endif
  if !hasmapto('<Plug>Titlecase', 'x') && maparg('gt', 'x') ==# ''
    xmap gt <Plug>Titlecase
  endif
  if !hasmapto('<Plug>TitlecaseLine', 'n') && maparg('gT', 'n') ==# ''
    nmap gT <Plug>TitlecaseLine
  endif
endif
