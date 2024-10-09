"Escape mappings
inoremap jk <ESC>
vnoremap jk <Esc>

"set numbering and relative as the default nubering configuration
"F2 toggles relative numbering
set number
set relativenumber
noremap <F2> :set relativenumber!<CR>

"Experimental new mappings for frequent searching tasks
"internal search deprecated, use * instead
" noremap <F3> yiw/<C-r>"<CR> 
"external search - don't carriage return, in case I want to change the scope 
noremap <F3> yiw:grep -r <C-r>" src

"Change the word under the cursor with the last yank
noremap <leader>r ciw<C-r>0<Esc>


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

"Automatically source the changes to vimrc when I save and close?
autocmd bufwritepost .vimrc source $MYVIMRC

"Vimwiki indents
let g:vimwiki_folding='custom'
autocmd BufRead,BufNewFile *.wiki set fdm=indent fml=3
"Vimwiki auto wrapping
autocmd BufRead,BufNewFile *.wiki set textwidth=100

"Some search settings
set ignorecase
set smartcase "Changes to case-sensitive search when capitals are used
set hls



"These settings are for vimwiki..."
set nocompatible
filetype plugin on
syntax on

"keymapping to allow me to quickly enable indentation folding
nnoremap zzi :set foldmethod=indent<CR>

set colorcolumn=80,100 

"Setting for netrw opening files into a vertical split"
let g:netrw_liststyle = 3 "tree view
let g:netrw_altv = 1 "opens to right
"let g:netrw_browse_split = 4 "open in previous window
"let g:netrw_winsize = 65 "adjustment of screen realestate

"Some settings for vim splits - kind of arbitratry
set splitright
set splitbelow

"keymapping for use with the quickfix list
nnoremap KN :cn<CR>
nnoremap KP :cp<CR>

"command to use make from cmd
nnoremap <F5> :set makeprg=cmd.exe\ /C\ make<CR>

"Automate installation of Vim Plug
"Might need some tweaks
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
" Using Vim-Plug
" run PlugIntall to install initially or PlugUpdate to update
let plugin_dir = '~/.vim/VimPluginDir'
call plug#begin(plugin_dir)
" Fancy looking dock bar
Plug 'vim-airline/vim-airline'                          
" ^and a colourscheme for it
Plug 'vim-airline/vim-airline-themes'                   

" Git integration
Plug 'tpope/vim-fugitive'                               
" Git commit browser - dependant on fugative
Plug 'junegunn/gv.vim'                                  

" Haskell support
Plug 'neovimhaskell/haskell-vim'                        

" Wiki and diary integration in vim 
Plug 'vimwiki/vimwiki'                                  
" Sync tool for vimwiki - requires vimwiki
Plug 'michal-h21/vimwiki-sync'                          

" fuzzy search finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     
Plug 'junegunn/fzf.vim'

" Asynchronous Linting Engine
Plug 'dense-analysis/ale'                               

" Python Code Formatter
Plug 'psf/black', {'branch': 'stable'}

" Some vim colourschemes to try
Plug 'sainnhe/gruvbox-material', { 'as': 'gruvbox-material'}
Plug 'sainnhe/everforest', { 'as': 'everforest'}
Plug 'sainnhe/sonokai', { 'as': 'sonokai'}
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }

call plug#end()

"Some color settings...
set t_Co=256
set background=dark
"A couple of interesting options: focuspoint, kuroi...
colorscheme sonokai

"Vim Airline Theme
let g:airline_theme='jellybeans'
let g:airline#extensions#whitespace#enabled = 0
