set guicursor=a:blinkon100
set ruler
set backspace=indent,eol,start
let &t_SI="\e[1 q"
let &t_SR="\e[1 q"
let &t_EI="\e[1 q"
colorscheme cyberpunk-neon
hi normal guibg=NONE ctermbg=NONE
hi clear SignColumn

set t_Co=16
set nocompatible              " required
filetype off                  " required


call plug#begin('~/.config/nvim/plugged')

Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tmhedberg/SimpylFold'
Plug 'ryanoasis/vim-devicons'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'https://github.com/snakemake/snakemake.git', {'rtp': 'misc/vim/'}
Plug 'snakemake/snakefmt'
Plug 'Yggdroot/indentLine'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'dense-analysis/ale'
Plug 'freitass/todo.txt-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdcommenter'
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-python/python-syntax'
Plug 'sheerun/vim-polyglot'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

call plug#end()

filetype plugin indent on
syntax on

set laststatus=0
set colorcolumn=80

let g:python_highlight_all = 1
let g:SimpylFold_docstring_preview=1
let g:coc_node_path = '/usr/bin/node'
"let g:conda_startup_msg_suppress = 1


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
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


"let g:indentLine_setColors = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
"let g:ale_lint_on_text_changed = 'never'

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
      else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif

        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

let g:ale_fixers = {
        \    'python': ['yapf'],
      \}
nmap <F10> :ALEFix<CR>
let g:ale_fix_on_save = 1

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " Insert <tab> when previous text is space, refresh completion if not.
  inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ <SID>check_back_space() ? "\<Tab>" :
	\ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
nmap <silent> xl <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>TroubleToggle loclist<CR>`

"nvim-tree remaps
noremap <C-t> :NvimTreeToggle<CR>

lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
  require("nvim-tree").setup({
  sort_by = "case_sensitive",
  open_on_setup = true,
  open_on_setup_file = true,
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
  end
})
EOF
