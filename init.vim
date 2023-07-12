set guicursor=a:blinkon100
set ruler
set backspace=indent,eol,start
"let &t_SI="\e[2 q"
"let &t_SR="\e[1 q"
"let &t_EI="\e[1 q"
colorscheme cyberpunk-neon
hi normal guibg=NONE ctermbg=NONE
hi clear SignColumn

"set t_Co=16
set nocompatible              " required
filetype off                  " required

set laststatus=0
set colorcolumn=80

set splitbelow
set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99


" Enable folding with the spacebar
nnoremap <space> za
highlight BadWhitespace ctermbg=red guibg=red

au FileType python setlocal ts=4 sts=4 sw=4 tw=79 et ai ff=unix 
au FileType markdown setlocal ts=4 sts=4 sw=4 et ai ff=unix 
au FileType snakemake setlocal ts=4 sts=4 sw=4 et ai ff=unix 
au FileType html setlocal ts=2 sts=2 sw=2 et ai ff=unix enc=utf-8
au FileType css setlocal ts=2 sts=2 sw=2 et ai ff=unix enc=utf-8
au FileType vim setlocal ts=2 sts=2 sw=2 et ai ff=unix enc=utf-8
au FileType sh setlocal ts=2 sts=2 sw=2 et ai ff=unix enc=utf-8
au FileType yaml setlocal ts=2 sts=2 sw=2 et ai ff=unix enc=utf-8
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
au BufNewFile,BufRead Snakefile,*.smk set filetype=snakemake
au FileType snakemake autocmd BufWritePre <buffer> execute ':Snakefmt'

let python_highlight_all=1
syntax on
syntax enable
