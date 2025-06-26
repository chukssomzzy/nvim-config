return {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = {
            -- add any custom options here
        },
        config = function()
            require('persistence').setup()
            -- Add keymaps for session management
            local map = vim.keymap.set
            map('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Restore Session' })
            map('n', '<leader>ql', function() require('persistence').load({ last = true }) end,
                { desc = 'Restore Last Session' })
            map('n', '<leader>qd', function() require('persistence').stop() end, { desc = 'Don\'t Save Session' })
        end,
    },

    -- Markdown Preview
    {
        'iamcco/markdown-preview.nvim',
        ft = { 'markdown' },
        build = function() vim.fn['mkdp#util#install']() end,
    },

    -- WakaTime for code stats
    { 'wakatime/vim-wakatime' },

    -- Rainbow Brackets via Treesitter
    {
        'p00f/nvim-ts-rainbow',
        -- You can also use 'rainbow-delimiters.nvim' as another option
    },

    -- Emmet support for nvim-cmp
    -- This makes Emmet suggestions appear in your completion menu
    {
        'dcampos/cmp-emmet-vim',
        dependencies = { 'nvim-cmp' },
    },
}
