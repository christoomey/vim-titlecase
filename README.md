# Vim Titlecase

Titlecase is a vim plugin that adds a new operator (command that takes a text
object or motion to act on) for titlecasing text.

       this is some text  |  this is Some text
     method('some args')  |  method('Some Args')
            a title line  |   A Title Line

## Usage

The main interface to the plugin is via the `<Plug>Titlecase` operator, by
default mapped to `gt`.

The `gt` mapping will wait for a text object or motion before completing the
titlecase operation. This means `gti'` will titlecase inside of single quotes,
`gtap` will titlecase a paragraph, etc. `gt` will also work on a visual
selection.

In addition, `gT` will titlecase the current line.

## Title-Casing Rules

The plugin lowercases all the: _ conjunctions _ articles \* prepositions

It leaves the word as is when: _ It is in all caps. _ It is specified in the
exclusion list `g:titlecase_excluded_words`.

And it capitalizes everything otherwise.

When used from `<Plug>TitlecaseLine` it capitalises the first and last word no
matter what.

## Caveats

The functionality of `<Plug>TitlecaseLine` unfortunately has an edgecase which
causes it to ignore the exclusion list for the first and last words. "the
fanciful tales of HTML" will be transformed to "The Fanciful Tales of Html"
while in "the ins and outs of the SPARC system" the all caps will be respected.
(I made these names up on the fly)

The plugin also doesn't take into account that the word after a colon needs to
be capitalized.

## Mappings

Be default titlecase maps itself to `gt`, but this interferes with the default
mapping for switching tabs. If you would like to disable the default maps, add
the following to your vimrc:

```vim
Bundle 'christoomey/vim-titlecase'

let g:titlecase_map_keys = 0
```

You can then add any mappings you would like with the following:

```vim
nmap <leader>gt <Plug>Titlecase
vmap <leader>gt <Plug>Titlecase
nmap <leader>gT <Plug>TitlecaseLine
```

```vim
<Plug>Titlecase " Titlecase the region defined by a text object or motion
<Plug>TitlecaseLine " Titlecase the entire line
```

## Word Exclusion

The variable `g:titlecase_excluded_words` can be used to specify which will be
left untouched. For example:

```vim
let g:titlecase_excluded_words = ["thoughtbot"]
```
