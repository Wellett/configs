"remap the esc key
"I think the jk option seems pretty good?
inoremap jk <ESC>

"I'm not actually sure what the leader key is?
""let mapleader = "<Space>"

"set relative nubering, seems like a good thing
set rnu

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
