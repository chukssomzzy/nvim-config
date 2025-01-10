source $HOME/.config/nvim/config/config.vim

lua << EOF
--require("lsp")
require("treesitter")
require("statusbar")
--require("completion")
--require("autoPairs")
require("autoSave")
require("telescope").load_extension("emoji")
require('luaSnip')
require('vimConfig')
require('changeSign')
--require("lspLines")
require("imageNvim")
require("mason").setup()
require("mason-lspconfig").setup()
require("lspConfig")
require('cmp-vars')
require('Comment').setup()
require("nvimFormatter")
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
--require('lspHover')
--require("telescope").load_extension("emoji_fzf")
require("tokyonight")
require("lspconfig_vim")
EOF
source $HOME/.config/nvim/config/cocNvim.vim
source $HOME/.config/nvim/config/cocSnippet.vim
source $HOME/.config/nvim/config/airline.vim
source $HOME/.config/nvim/config/copilot.vim
"source $HOME/.config/nvim/config/saga.vim
"source $HOME/.config/nvim/config/emoji.vim
