require'nvim-treesitter.configs'.setup {
    -- ensure_installed can be "all" or a list of languages { "python", "javascript" }
    ensure_installed = {
        "python",
        "bash",
        "javascript",
        "clojure",
        "go",
        "typescript",
        "c",
        "markdown",
        "markdown_inline"
    },

    sync_install = false,

    auto_install = true,


    highlight = { -- enable highlighting for all file types
        enable = true, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })

        disable = function(lang, buf)
            local max_filesize = 1024 * 100
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size < max_filesize then
                return true
            end
        end,
    },

    incremental_selection = {
        enable = true,  -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
        keymaps = {                       -- mappings for incremental selection (visual mappings)
            init_selection = "gnn",         -- maps in normal mode to init the node/scope selection
            node_incremental = "grn",       -- increment to the upper named parent
            scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
            node_decremental = "grm",       -- decrement to the previous node
        }
    },
    textobjects = {
        -- These are provided by 
        select = {
            enable = true,  -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
            keymaps = {
                -- You can use the capture groups defined here:
                -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/c/textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["as"] = "@statement.outer",
                ["is"] = "@statement.inner",
            },
        },
    },
    indent = {
        enable = true
    }
}
