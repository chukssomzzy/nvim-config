

function! Main()
    try
        call LoadPlugins()
    catch
        call VimPlugInstall()
    endtry
    call Settings()
    call Mappings()
    call SettingFiletypes()
    call SettingPlugins()
endfunction 
function! LoadPlugins()
    " >> load plugins
    call plug#begin(stdpath('data') . 'vimplug')
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    "debugg adapter
    Plug 'mfussenegger/nvim-dap'
    "formerter neovim
    Plug 'mhartington/formatter.nvim'
    "telescope load_extension 
    Plug 'xiyaowong/telescope-emoji.nvim'
    "Plug 'pschmitt/telescope-emoji-fzf.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'cocopon/iceberg.vim' 
    Plug 'NTBBloodbath/galaxyline.nvim', { 'branch': 'main' } "Maintained .config/nvim/init.vim-airline
    Plug 'kyazdani42/nvim-web-devicons'  " needed for galaxyline icons
    "theme
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
    Plug 'nikvdp/neomux'

    Plug 'tpope/vim-ragtag'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'
    Plug 'BurntSushi/ripgrep'
    Plug 'vim-utils/vim-man' 
    Plug 'tomtom/tcomment_vim'
    "Nerd Tree (cnot) survive without this shit
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter' 
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
    "hover effect in nvim let try it
    Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
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
    Plug 'Pocco81/auto-save.nvim'
    "syntax highlighting for vim
    Plug 'sheerun/vim-polyglot'
    "git gutter
    "Plug 'akiomik/git-gutter-vim'
    "vim themes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    "github copilo
    "Plug 'github/copilot.vim'
    "lint
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'Th3Whit3Wolf/space-nvim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'powerline/powerline' 
    Plug 'luochen1990/rainbow'|                     "color brackets  
    Plug 'samodostal/image.nvim'
    Plug 'mfussenegger/nvim-dap-python'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'JuanDAC/betty-ale-vim'
    Plug 'dense-analysis/ale'|                  "linting program
    Plug 'chrisbra/changesplugin'|              "show changes in git
    Plug 'rust-lang/rust.vim'
    if executable('ctags')
        Plug 'ludovicchabant/vim-gutentags' 
        "Plug 'codota/tabnine-vim'|                  "It needs clangd-9 to works
        "Plug 'mg979/vim-visual-multi'               "Multi cursor
    else
        Plug 'vim-syntastic/syntastic'|             "Ale alternative for vim 700
        Plug 'szw/vim-tags'|                        "create tags :TagsGenerate[!] it needs exuberant-tags package
        if executable('autopep8')
            "Plug 'tell-k/vim-autopep8'|             "Edit files acording to pep8
        endif
    endif
    "Plug 'Athesto/vim-betty'|

    call plug#end()
endfunction



" basic settings
set encoding=utf-8                                "encoding file for unicodes and accents
scriptencoding utf-8 
function! Settings()
    syntax on
    set autoindent
    set number
    set nowrap 
    set cursorline                                    "highlight the line at the cursor 
    set numberwidth=1
    set relativenumber
    set splitright                                    "split buffers at right 
    set ignorecase      " ignore case
    set smartcase     " but don't ignore it, when search string contains uppercase letters
    set nocompatible
    set incsearch        " do incremental searching
    set visualbell
    set expandtab
    set tabstop=8
    set ruler
    set smartindent
    set shiftwidth=4
    set hlsearch
    set virtualedit=all
    set backspace=indent,eol,start " allow backspacing over everything in insert mode
    set cindent
    set autoindent
    set mouse=a  " mouse support
    set swapfile "set swapfile
    "set background = light
    set completeopt=menu,menuone,noselect
    "set clipboard 
    set clipboard=unnamedplus
    " set leader key to ,
    set t_Co=256                                      "patch, set explicit 256 colors for term w/o 256-color
    set t_u7=""                                       "patch, resolve starting with REPLACE mode on (Windows problem) https://github.com/vim/vim/issues/6365#issuecomment-652299438
    set t_ut=""                                       "patch, resolve whitespace color problem https://github.com/microsoft/terminal/issues/832
    set undodir=~/.config/.nvim/undodir                        "Undo directory for undo buffer
    set backupdir=~/.config/.nvim/backupdir                    "backupdir
    set backup
    set undofile "save undo buffer in (undodir)ectory 
    set foldlevelstart=99                             "Folds search about :help usr_28 
    highlight clear                                   "Clean highlight must go before colorscheme
    try
        "colorscheme challenger_deep                   "Explicit colorscheme
        colorscheme iceberg | set background=dark     "Iceberg dark
    catch
        colorscheme tokyonight
    endtry

endfunctio
function! CustomList()
    set list                                            "show special chars
    set listchars=|                                     "resetListchars
    set listchars+=tab:├┄                               "i_<C-v> u251c u2504
    set listchars+=tab:›·                               "i_<C-v> u203a u02fd
    set listchars+=tab:│\                               "i_<C-v> u2502 <space>
    set listchars+=tab:│·                               "i_<C-v> u2502 u02fd
    set listchars+=trail:˽                              "i_<C-v> u02fd
    set listchars+=trail:·                              "i_<C-v> u02fd
    let g:mySKfg=235
    execute 'hi SpecialKey ctermfg ='.g:mySKfg
endfunction
function! Mappings()
    let g:mapleader=" "
    " >> Telescope bindings
    "normal mode
    nnoremap <C-@> <C-^>zz|                             " n_C-<space>     -> go to last open file"
    nnoremap <C-T>b :tab ba<CR>                         " n_C-t-b         -> tab from buffer
    nnoremap <C-T>o :tabonly<CR>                        " n_C-t-o         -> only one tab
    "buffer mapping
    nnoremap <leader><leader>h :bprevious<CR>
    nnoremap <leader><leader>l :bnext<CR> 
    nnoremap <leader><leader>q :bdelete<CR>
    nnoremap <leader><leader>E :EmmetInstall<CR> 
    "install emmet in current buffer
    "lsp mapping
    nnoremap s<leader> :LspStop<CR> 
    " stops LspStop 
    nnoremap st<leader> :LspStart<CR> 
    " start lsp
    nnoremap r<leader> :LspRestart<CR>
    "restart lsp
    nnoremap <F3> :set wrap!<CR>:set wrap?<CR>|         " n_<F3>          -> toggle wrap

    nnoremap <F4> :set nu! list!<CR>|                   " n_<F4>          -> toggle numbers
    nnoremap <esc>h :tabrewind<CR>|                   " n_M-h           -> goto previous tab (more confortable)
    nnoremap <esc>l :tabnext<CR>|                       " n_M-l           -> goto next tab (more confortable)
    nnoremap <leader><esc> :nohl<CR>|                   " n_<leader><esc> -> clean format
    nnoremap <leader>U magUiw`a|                        " n_<leader>U     -> uppecase word
    "nnoremap <leader><leader>w :call WriteForced()<CR>| " n_<leader><leader>w -> sudo save
    nnoremap <leader>a ggVG|                            " n_<leader>U     -> select all document

    nnoremap <leader>b :BuffergatorToggle<CR>|          " n_<leader>b     -> Toggle BufferTree
    "nnoremap <leader>b :Buffers<CR>|                   " n_<leader>b     -> fzf buffer finder
    nnoremap <leader>h :NERDTreeToggle<CR>|             " n_<leader>e     -> toggle FileExplorer (NERDTree)
    nnoremap <leader>ff :files<CR>|                     " n_<leader>f     -> using fzf as file finder
    nnoremap <leader>fb :buffers<CR>|                     " n_<leader>f     -> using fzf as file finder
    nnoremap <leader>f.. :FZF ..<CR>|                   " n_<leader>f     -> using fzf as file finder

    nnoremap <leader>fh :FZF ~<CR>|                     " n_<leader>f     -> using fzf as file finder
    nnoremap <leader>i magg=G'a|                        " n_<leader>i     -> indent file
    " nnoremap <leader>q :q<CR>|                          " n_<leader>q     -> quit
    nnoremap <leader>q :call Bye()<CR>|                 " n_<leader>q     -> (buffers > 1) ? buffer delete : quit
    nnoremap <leader>r :e<CR>|                          " n_<leader>r     -> reload file
    nnoremap <leader>u maguiw`a|                        " n_<leader>u     -> lowercase word
    nnoremap <leader>w :w<CR>|                          " n_<leader>w     -> save
    nnoremap <leader>xe :call EditVIMRC()<CR>|          " n_<leader>xe    -> edit VIMRC
    nnoremap G Gzz|                                     " n_G             -> center windows after search end nnoremap H :bprevious<CR>zz|                        " n_Meta-h        -> goto previous buffer (more confortable)
    nnoremap L :bnext<CR>zz|                            " n_Meta-l        -> goto next buffer (more confortable)
    nnoremap gp `[v`]|                                  " n_gp            -> select pasted text
    "nnoremap R <Esc>|                                   " n_R            -> patch, Disable ReplaceMode (Fix Windows OS Problems)
    nnoremap [b :bprevious<CR>|                         " n_[-b           -> goto previous buffer
    nnoremap [e :ALEPrevious<CR>|                       " n_[-K           -> goto previous ALE_Error
    nnoremap [t :tabprevious<CR>|                       " n_[-K           -> goto previous tab
    nnoremap ]b :bnext<CR>|                             " n_]-K           -> goto next buffer
    nnoremap ]e :ALENext<CR>|                           " n_]-K           -> goto next ALE Error
    nnoremap ]t :tabnext<CR>|                           " n_]-K           -> goto next tab
    "nnoremap g<F1> :help <C-R><C-F><CR>|               " n_g<F1>        -> use insted K on the word open help for word under the cursor Ex. use g<F1> -> cmdline
    "nnoremap q: <nop>|                                 " n_q:           -> disable history windows (it gives me conficts)
    nnoremap <esc>j :move +1<CR>==|                     " n_Meta-j        -> move line below and format line
    nnoremap <esc>k :move -2<CR>==|                           " n_Meta-k        -> move line above and format line

    " mapping  [ cmdline-mode ]
    cnoremap <C-A> <Home>|                              " c_Ctrl-A    -> go to Beginning of line
    cnoremap <C-B> <Left>|                              " c_Ctrl-b    -> backward a char
    cnoremap <C-F> <Right>|                             " c_Ctrl-f    -> fordward a char
    cnoremap <C-d> <Right><BS>|                         " c_Ctrl-d    -> delete char forward
    cnoremap <esc><BS> <C-W>|                           " c_Meta-DEL  -> delete word backward
    cnoremap <esc>b <S-Left>|                           " c_Meta-b    -> backward a word
    cnoremap <esc>d <S-Right><Right><C-W>|              " c_Meta-d    -> delete word forward
    cnoremap <esc>f <S-Right>|                          " c_Meta-f    -> fordward a word

    " mapping [ visual-mode ]

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
    nnoremap <Leader># <cmd>lua require'telescope.builtin'.colorscheme{}<CR>

    " >> setup nerdcomment key bindings
    let g:NERDCreateDefaultMappings = 0
    let g:NERDSpaceDelims = 1

    nnoremap <Leader>Cc <cmd>call NERDComment('n', 'toggle')<CR>


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
    xnoremap <silent> gA   <cmd>Lspsaga range_code_action<CR>
    nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR> 
endfunction
"another fun
function! SettingFiletypes()
    augroup Filetypes
        autocmd!
        au BufNewFile,BufRead *.ts setlocal filetype=typescript
        au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
        autocmd BufNewFile,BufRead *.asm        set filetype=nasm
        autocmd BufNewFile,BufRead *.sh         set filetype=bash
        autocmd BufNewFile,BufRead *.cfg        set filetype=conf
        autocmd BufNewFile,BufRead *.h          set filetype=c
        autocmd BufNewFile,BufRead *.pp         set filetype=puppet
        autocmd BufNewFile,BufRead man_[1-9]_*  set filetype=nroff
        autocmd Filetype sh                     set expandtab sw=4 ts=4 sts=4
        autocmd Filetype sql                    set expandtab sw=2 ts=2 sts=2
        autocmd Filetype json                   set expandtab sw=2 ts=2 sts=2
        autocmd Filetype c                      set noexpandtab sw=4 ts=4 sts=4 keywordprg=:Man "explicit, I had problem with nasm and c
        autocmd Filetype nasm                   set expandtab sw=8 ts=8 sts=8
        autocmd Filetype conf                   set expandtab
        autocmd Filetype html                   set expandtab sw=2 ts=2 sts=2
        autocmd Filetype htmldjango             set expandtab sw=4 ts=4 sts=4 
        autocmd Filetype javascript             set expandtab sw=4 ts=4 sts=4
        autocmd Filetype yaml                   set expandtab sw=4 ts=4 sts=4
        autocmd Filetype python                 set expandtab sw=4 ts=4 sts=4 fdm=indent
        autocmd Filetype puppet                 set expandtab
        autocmd Filetype ruby                   set expandtab sw=4 ts=4 sts=4
        autocmd Filetype python                 set expandtab sw=4 ts=4 sts=4 keywordprg=:!python3\ -m\ pydoc
        autocmd Filetype vim                    set expandtab sw=4 ts=4 sts=4

        let g:html_indent_inctags = ''                      "autointent new line after enter
        let g:html_indent_autotags = 'p,html'               "no autoindent with format
        autocmd Filetype htmldjango RainbowToggle
        autocmd Filetype htmldjango EmmetInstall 

        augroup highlight_over80
            autocmd!
            autocmd Filetype * highlight OverLength ctermbg=167 ctermfg=234 guibg=#592929
            autocmd Filetype * match OverLength //|                                 "patch, 1. edit py, 2. edit another file
            autocmd Filetype c,python match OverLength /\%80v./
        augroup END

        augroup auto_format_nasm
            autocmd BufWritePost *.asm call Nasmfmt()
        augroup END

        augroup Remove_trailing_whitespaces
            autocmd BufWritePre *.py,*.c,*.h,*.js,*.html  %s/\s\+$//e
        augroup END

        augroup mysql
            autocmd!
            "autocmd BufWritePre *.sql
        augroup END
    augroup END
endfunction
"settings plugin
function! SettingPlugins()
    augroup Plugins_Filetypes
        autocmd!
        "autocmd FileType html, css, javascript ,typescript.tsx ,markdown EmmetInstall                                   "only use in css and html
        autocmd FileType nerdtree RainbowToggleOff                               "Disable Rainbow brackets in NERDTree
        autocmd Filetype c,sh let g:NERDSpaceDelims = 2                             "NerdCommenter spaces 1
        autocmd Filetype fugitive
                    \ nnoremap <buffer> <leader>?
                    \ :below vertical help fugitive-maps<cr> |                   "remap g? right split the help messages
    augroup END

    if !exists('g:airline_symbols')
        let g:airline_symbols = {'dirty':'*', 'crypt':'Cr'}                      "Fix airline-icons (2) spaces [ airline-customization ]
    endif
    let g:airline_left_sep = "\ue0bc"                                            "left icon as diagonal -> https://github.com/ryanoasis/powerline-extra-symbols#glyphs
    let g:airline_powerline_fonts = 1                                            "use the nerd-font
    let g:airline_right_sep = "\ue0be"                                           "right icon as diagonal
    "" let g:airline_theme = 'minimalist'                                           "airline themes -> https://github.com/vim-airline/vim-airline/wiki/Screenshots

    let g:ale_fixers = {
                \'rust': ['rustfmt'],
                \'python' : ['autopep8'],
                \'html' : ['prettier'],
                \'javascript': ['standard']}
    let g:ale_linters = {
                \'rust': ['rustc', 'rls', 'cargo'],
                \'python' : ['flake8'],
                \'c':['betty-style', 'betty-doc','gcc'],
                \'javascript': ['standard']}
    let g:ale_c_cc_options = '-std=gnu90 -Wall -Wextra -Werror -pedantic'        "c options
    let g:ale_nasm_nasm_options = '-f elf64'
    let g:ale_fix_on_save = 1                                                    "fixautopep after save file
    let g:ale_javascript_standard_executable = 'semistandard'                    "set semistandard executable as standard
    let g:ale_javascript_standard_options = '--global $'                         "disable jquery warning
    let g:ale_javascript_standard_use_global = 1
    "let g:ale_python_pycodestyle_executable = 'pep8'
    let g:ale_python_flake8_use_global = 1
    let g:ale_python_flake8_options = '--ignore=E241,E501'                            "501(80chars)
    "let g:ale_python_flake8_options = '--ignore=E241,E402,E501'
    let g:ale_set_highlights = 0 " Disable highligting
    set omnifunc=ale#completion#OmniFunc

    let g:NERDCustomDelimiters = { 'nroff': { 'left': '.\\"'} }                  "NERDCommenter has problems with backslash
    let g:NERDDefaultAlign = 'left'
    let g:autopep8_disable_show_diff=1                                           "disable diff
    let g:autopep8_on_save = 1                                                   "Run autopep8 everytime that save
    let g:buffergator_suppress_keymaps = 1                                       "Let me set <leader>b as BuffergatorToggle
    let g:changes_vcs_check = 1                                                  "enable git check
    let g:gutentags_ctags_tagfile = '.git/tags'                                  "set tags into the .git directory
    let g:indentLine_char = '│'                                                  "using for indentation i_<C-v> u203a u02fd
    "let g:indentLine_color_term = g:mySKfg                                         "set color as the colorscheme
    let g:neomake_shellcheck_args = ['-fgcc']                                    "[deprecated] fix ERROR with neomake and shellcheck
    let g:rainbow_active = 1                                                     "set to 0 if you want to enable it later via :RainbowToggle
    let g:user_emmet_install_global = 0                                          "disable emmet globally
    let g:user_emmet_settings = {
                \  'javascript.jsx' : {
                    \      'extends' : 'jsx',
                    \  },
                    \}

    let g:syntastic_c_compiler_options =
                \'-std=gnu90 -Wall -Wextra -Werror -pedantic'

    let g:NERDTreeNaturalSort = 1                                                "NerdTree sort 1, 2, 3, 100, 1000
    augroup myBufenter
        autocmd!
        "autocmd bufwinenter * silent NERDTreeMirror                                  "Open the existing NERDTree on each new tab.
        autocmd bufenter * if (winnr("$") == 1 &&
                    \exists("b:NERDTree") &&
                    \b:NERDTree.isTabTree()) | q | endif                         "close all if there is only one window
    augroup END

endfunction

function! VimPlugInstall()
    silent !mkdir -p $HOME/.config/.nvim/undodir
    silent !mkdir -p $HOME/.config/.nvim/backupdir

    if !executable('git')
        echohl WarningMsg | echomsg 'Warning: Vim-plug needs git to install the plugins' | echohl None
        return
    endif

    if !executable('curl')
        echohl WarningMsg | echomsg 'Warning: Vim-plug needs curl for the installation' | echohl None
        return
    endif

    if !exists('*plug#begin')
        silent !echo -e "\033[0m\033[31m\nOh no\!, Vim-plug manager is not found, Don't worry, I will install it\033[0m"
        ! sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call Main()
        PlugInstall
        quit
    endif
endfunction
function! Bye()
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        :q
    else
        :bdelete
    endif
endfunction 

function! Nasmfmt()
    """ Format the nasm file with the
    binary nasmfmt, repo -> https://github.com/yamnikov-oleg/nasmfmt
    if executable('nasmfmt')
        execute ':silent !nasmfmt -ci 35 %'
        edit!   "don't need L<CR> for reload
        redraw! "it's necesary you call the function manually
    endif
endfunction
function! EditVIMRC()
    execute ':silent tabedit $MYVIMRC'
    echom '.vimrc'
endfunction

call Main()


