" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.dotfiles/nvim/plugged')
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "completion
" Plug 'kamykn/spelunker.vim' "spell check
" Plug 'zchee/deoplete-jedi' "completion
Plug 'drewtempelmeyer/palenight.vim'
Plug 'romgrk/doom-one.vim'
Plug 'rafalbromirski/vim-aurora'
Plug 'vim-airline/vim-airline' "airline bar
Plug 'tmhedberg/SimpylFold' "easy fold
Plug 'neomake/neomake' "multithreading
Plug 'tpope/vim-fugitive' "git functionality
Plug 'christoomey/vim-tmux-navigator' "tmux integration
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'tpope/vim-commentary' "easy comment lines
Plug 'takac/vim-hardtime' "remove bad habits
Plug 'roxma/vim-tmux-clipboard' "solves clipboard headaches
Plug 'francoiscabrol/ranger.vim' "ranger for nvim
Plug 'rbgrouleff/bclose.vim' "ranger for nvim (autoclose buffer)
" Plug 'vuciv/vim-bujo' "todo list
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'eandrju/cellular-automaton.nvim'
call plug#end()

" *** Tmux Navigator ***
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_save_on_switch = 2

" *** Cellular-automaton ***
lua << automaton
local config = {
    fps = 50,
    name = 'snake',
}

-- init function is invoked only once at the start
-- config.init = function (grid)
--
-- end

-- update function
config.update = function (grid)
    for i = 1, #grid do
        local prev = grid[i][#(grid[i])]
        for j = 1, #(grid[i]) do
            grid[i][j], prev = prev, grid[i][j]
        end
    end
    return true
end

require("cellular-automaton").register_animation(config)

automaton

nnoremap <silent> <leader>mir :CellularAutomaton make_it_rain<CR>j
nnoremap <silent> <leader>fml :CellularAutomaton game_of_life<CR>j
nnoremap <silent> <leader>sn :CellularAutomaton snake<CR>j

"
" *** Tree-sitter ***
lua << treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "vim", "bash", "lua", "python", "cuda", "html", "cmake", "make", "yaml", "vim"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}
treesitter
"*** EasyMotion ***
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
nmap s <Plug>(easymotion-overwin-f)

" *** CoC ***

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"


set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <leader>j coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <leader>k coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <leader>j  coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <leader>k coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <leader>j coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <leader>k coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

command! -nargs=0 Format :call CocActionAsync('format')



" *** Airline ***
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = "palenight"
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" *** SimpylFold ***
let g:SimpylFold_docstring_preview = 1

" " *** Spelunker ***
" let g:spelunker_check_type = 2
" set updatetime=1000

" *** Doge ***
let g:doge_doc_standard_python = 'google'
let g:doge_enable_mappings=0

" *** HardTime ***
let g:hardtime_default_on = 0
let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_insert_keys = []
let g:hardtime_timeout = 1000
let g:hardtime_showmsg = 1
let g:hardtime_allow_different_key = 1

" *** FzF ***
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore output --ignore "*.json" --ignore "*.txt"', fzf#vim#with_preview(), <bang>0)
nmap <C-p> :Files<cr>|
nmap <C-F>f :Ag!<cr>|
nmap <C-F>/ :BLines<cr>|
nmap <C-F>b :Buffers<cr>|
