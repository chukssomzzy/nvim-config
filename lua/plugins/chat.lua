return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				-- You can customize suggestions and panel here if needed
				-- See the plugin's documentation for options
			})
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- IMPORTANT: Changed dependency
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			window = {
				layout = "vertical",
				width = 0.5,
				height = 0.9,
			},
		},
	},
}
