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

Word Exclusion
--------------

The variable `g:titlecase_excluded_words` can be used to specify which will be
left untouched. For example:

``` vim
let g:titlecase_excluded_words = ["thoughtbot"] 
```

Title-Casing Rules
------------------

The plugin lowercases all the:
    * conjunctions
    * articles
    * prepositions

It leaves the word as is when:
    * It is in all caps.
    * It is specified in the exclusion list `g:titlecase_excluded_words`.

And it capitalizes everything otherwise.

When used from `<Plug>TitlecaseLine` it capitalises the first and last word no
matter what.

Caveats
-------

The functionality of `<Plug>TitlecaseLine` unfortunately has an edgecase which
causes it to ignore the exclusion list for the first and last words. "the
fanciful tales of HTML" will be transformed to "The Fanciful Tales of Html"
while in "the ins and outs of the SPARC system" the all caps will be respected.
(I made these names up on the fly)

The plugin also doesn't take into account that the word after a colon needs to
be capitalized.

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
