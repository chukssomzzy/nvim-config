return {
	-- File explorer
	{
		"preservim/nerdtree",
		cmd = "NERDTreeToggle",
		config = function()
			vim.g.NERDTreeWinSize = 40
		end,
	},

	-- Git integration
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
	},
}
