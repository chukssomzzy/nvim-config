return {

	-- Markdown Preview
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- WakaTime for code stats
	{ "wakatime/vim-wakatime" },

	-- Rainbow Brackets via Treesitter
	{
		"p00f/nvim-ts-rainbow",
		-- You can also use 'rainbow-delimiters.nvim' as another option
	},

	-- Emmet support for nvim-cmp
	-- This makes Emmet suggestions appear in your completion menu
	{
		"dcampos/cmp-emmet-vim",
		dependencies = { "nvim-cmp" },
	},

	-- Todo comments highlighting
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"tpope/vim-obsession",
	},
}
