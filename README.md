Vim Titlecase
=============

Titlecase is a vim plugin that adds a new operator (command that takes a text
object or motion to act on) for titlecasing text.

       this is some text  |  this is Some text
     method('some args')  |  method('Some Args')
            a title line  |   A Title Line

Usage
-----

The main interface to the plugin is via the `<Plug>Titlecase` operator, by
default mapped to `gz`.

The `gz` mapping will wait for a text object or motion before completing the
titlecase operation. This means `gzi'` will titlecase inside of single quotes,
`gzap` will titlecase a paragraph, etc. `gz` will also work on a visual
selection.

In addition, `gzz` will titlecase the current line.

Mappings
--------

Be default titlecase maps itself to `gz`. 
If you would like to disable the default maps, add the following to your vimrc:

``` vim
Bundle 'christoomey/vim-titlecase'

nmap <leader>gz  <Plug>Titlecase
vmap <leader>gz  <Plug>Titlecase
nmap <leader>gzz <Plug>TitlecaseLine
```

``` vim
<Plug>Titlecase " Titlecase the region defined by a text object or motion
<Plug>TitlecaseLine " Titlecase the entire line
```
