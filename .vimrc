"remap the esc key
"I think the jk option seems pretty good?
inoremap jk <ESC>

"I'm not actually sure what the leader key is?
""let mapleader = "<Space>"

"set numbering and relative nubering, seems like a good thing
set nu
set rnu

"use autoindent: I feel like this should be just standard
set autoindent

"Some whitespace settings
"In general keep shiftwidth == softtabstop == tabstop
"tabstop: width of a tab character 
set tabstop=4
"shiftwidth: how many spaces to insert when using indentaion tools
set shiftwidth=4
"Can still backspace full tabs even though they are expanded
set softtabstop=4
"Change tabs to spaces
set expandtab

"Some color settings...
set t_Co=256
set background=dark
"A couple of interesting options: focuspoint, kuroi...
colorscheme kuroi

