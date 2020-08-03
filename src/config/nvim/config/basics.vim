" Basic settings
" ==============

" This file contains a swath of fundamental settings. We'll start by enabling
" syntax highlighting and automatic indentation:

syntax on
filetype plugin indent on

" Next we'll set our "leader" key, which is comma (`,`). Later we'll
" define some custom mappings, and whenever we use them we will always precede
" those mappings with a comma. The comma is a pretty easy key to press and
" doesn't require our fingers to do too much work.

let mapleader = ","
let maplocalleader = ","

" Next we'll turn on line numbering and show the current line and column number
" in the status bar:

set number
set ruler

" Vim, like the shell, remembers commands you've run in the past. There are five
" different categories of commands it remembers, including Ex commands (which
" are always preceded by `:`) and search strings. You can adjust how many
" commands it remembers, and here we ensure that this number is large so we can
" effectively go back as far as we want to:

set history=1000

" Usually when you close a buffer, it's removed from memory, which means that
" the next time you open that buffer Vim has to parse it again. This default
" likely comes from the days when computers didn't have a whole lot of memory to
" go around, but we don't have to worry about that. So it's a slightly better
" experience if we keep buffers around all of the time:

set hidden

" When Vim starts, it displays a splash screen. Surely we don't need to be
" reminded each time that we're using Vim or that Bram Moolenar created it, do
" we?

set shortmess+=I

" As you may know, when you use Vim, you're bouncing between Insert and Command
" mode all the time, and so you end up pressing Escape a lot. You might have
" even configured your keyboard so you can do this more esaily. " By default,
" however, there is a slight delay built in after you press the key. This
" setting disables that delay so Vim feels more snappy.

set timeoutlen=1000 ttimeoutlen=0

" Sometimes it's necessary to tell Vim what type of file you're editing so that
" it can apply the correct syntax highlighting. These are called "mode lines",
" and often you'll place them at the bottom of the file in a comment so as not
" to draw attention. For instance, if we wanted to mark a file as Ruby, and the
" file didn't end in `*.rb`, we could add `# vi: ft=ruby` at the bottom. This
" setting enables this feature:

set modeline modelines=10

" In Ruby and other languages, `#` at the beginning of the line (disregarding
" whitespace) denotes a comment. For some reason, if you start typing a comment
" on an indented line, Vim will completely de-indent your line. This is caused
" by the `smartindent` setting, and we just need to turn it off
" ([source][so-1]).
"
" [so-1]: http://stackoverflow.com/questions/2063175/vim-insert-mode-comments-go-to-start-of-line

set nosmartindent

" Mode lines let you override Vim settings on a per-file basis. But what if you
" want to override settings for an entire project? Then you can keep those
" settings in a `.nvimrc` file within that project directory. These settings
" enable that ability:

set exrc secure

" While we don't expect to be using Backspace a lot in Insert mode, sometimes
" it's handy. For some reason, it's a bit limited in what you can actually
" delete. The following setting removes that limitation:

set backspace=indent,eol,start

" What's in a word? By default it is a underscore, but dashes are valid
" characters too:
set iskeyword+=-

" Finally, one of the more irritating things in Vim is the fact that as you type
" complex commands (e.g. `ciw`, `vp`, etc.) there's no way to know what you've
" typed -- and therefore no way to know whether you've typed the right thing --
" until you've finished the whole command. This setting places each keystroke in
" the status bar so you get the missing feedback:

set showcmd
