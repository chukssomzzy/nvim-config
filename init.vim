" >> load plugins
call plug#begin(stdpath('data') . 'vimplug')
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    "telescope load_extension 
    Plug 'xiyaowong/telescope-emoji.nvim'
    Plug 'sharkdp/fd'
    "Plug 'pschmitt/telescope-emoji-fzf.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer', { 'branch': 'main' }
    Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    Plug 'NTBBloodbath/galaxyline.nvim', { 'branch': 'main' } "Maintained .config/nvim/init.vim-airline
    Plug 'kyazdani42/nvim-web-devicons'  " needed for galaxyline icons

    Plug 'NLKNguyen/papercolor-theme'
    Plug 'nikvdp/neomux'

    Plug 'tpope/vim-ragtag'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'

    Plug 'tomtom/tcomment_vim'
    "Nerd Tree cannot survive without this shit
  Plug 'preservim/nerdtree'
    "completion
   Plug 'hrsh7th/cmp-emoji'
   Plug 'hrsh7th/cmp-buffer'
   Plug 'hrsh7th/cmp-path'
   Plug 'hrsh7th/cmp-nvim-lsp'
   Plug 'hrsh7th/vim-vsnip'
   Plug 'hrsh7th/vim-vsnip-integ'
   Plug 'L3MON4D3/luaSnip'
   Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

       "coc nvim
   " Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
   "emmet vim
   Plug 'mattn/emmet-vim'
   "snippet engine
   Plug 'dsznajder/vscode-es7-javascript-react-snippets', { 'do': 'yarn install --frozen-lockfile && yarn compile' }
   "coc-pairs
  "Plug 'neoclide/coc-pairs',{'branch':'master'}
   "autosave
   Plug 'Pocco81/AutoSave.nvim'
   "syntax highlighting for vim
   Plug 'sheerun/vim-polyglot'
   "git gutter
   "Plug 'akiomik/git-gutter-vim'
   "vim themes
   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'
   "github copilot
   Plug 'github/copilot.vim'
   Plug 'Th3Whit3Wolf/space-nvim'
   Plug 'ryanoasis/vim-devicons'
   Plug 'powerline/powerline'
call plug#end()



colorscheme PaperColor

" basic settings
syntax on
set number
set relativenumber
set ignorecase      " ignore case
set smartcase     " but don't ignore it, when search string contains uppercase letters
set nocompatible
set incsearch        " do incremental searching
set visualbell
set expandtab
set tabstop=4
set ruler
set smartindent
set shiftwidth=4
set hlsearch
set virtualedit=all
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set mouse=a  " mouse support
set swapfile "set swapfile
set completeopt=menu,menuone,noselect
 "set clipboard 
 "set clipboard=unnamedplus
" set leader key to ,
let g:mapleader=" "

" >> Telescope bindings
nnoremap <Leader>pp <cmd>lua require'telescope.builtin'.builtin{}<CR>

" most recently used files
nnoremap <Leader>m <cmd>lua require'telescope.builtin'.oldfiles{}<CR>

" find buffer
nnoremap ; <cmd>lua require'telescope.builtin'.buffers{}<CR>

" find in current buffer
nnoremap <Leader>/ <cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>

" bookmarks
nnoremap <Leader>' <cmd>lua require'telescope.builtin'.marks{}<CR>

" git files
nnoremap <Leader>f <cmd>lua require'telescope.builtin'.git_files{}<CR>

" all files
nnoremap <Leader>bfs <cmd>lua require'telescope.builtin'.find_files{}<CR>

" ripgrep like grep through dir
nnoremap <Leader>rg <cmd>lua require'telescope.builtin'.live_grep{}<CR>

" pick color scheme
nnoremap <Leader>cs <cmd>lua require'telescope.builtin'.colorscheme{}<CR>

" >> setup nerdcomment key bindings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

xnoremap <Leader>ci <cmd>call NERDComment('n', 'toggle')<CR>
nnoremap <Leader>ci <cmd>call NERDComment('n', 'toggle')<CR>


" >> Lsp key bindings
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K     <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ga    <cmd>Lspsaga code_action<CR>
xnoremap <silent> ga    <cmd>Lspsaga range_code_action<CR>
nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR>
lua <<EOF
require("lsp")
require("treesitter")
require("statusbar")
--require("completion")
--require("autoPairs")
require("autoSave")
require("telescope").load_extension("emoji")
require('cmp-vars')
require('luaSnip')
require('vimConfig')
require('changeSign')
require("lsp_lines").setup()
require("lspLines")
--require("telescope").load_extension("emoji_fzf")
EOF
source $HOME/.config/nvim/config/cocNvim.vim
source $HOME/.config/nvim/config/cocSnippet.vim
source $HOME/.config/nvim/config/airline.vim
source $HOME/.config/nvim/config/copilot.vim
"source $HOME/.config/nvim/config/clipboard.vim
"source $HOME/.config/nvim/config/space.vim
 "source $HOME/.config/nvim/config/emoji.vim


  

