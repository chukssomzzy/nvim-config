return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'vim', 'vimdoc', 'lua', 'bash', 'c', 'cpp', 'go',
                'html', 'css', 'javascript', 'typescript', 'tsx',
                'json', 'markdown', 'markdown_inline', 'python', 'rust',
                'vue', 'graphql'
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
