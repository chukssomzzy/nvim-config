vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.env.TERM_PROGRAM = "sixel"
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration modules
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Setup and load plugins via lazy.nvim
require("lazy").setup({
	spec = {
		-- Import all plugin configurations from the plugins directory
		{ import = "plugins.lsp" },
		{ import = "plugins.telescope" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.ui" },
		{ import = "plugins.editing" },
		{ import = "plugins.tools" },
		{ import = "plugins.formatting" },
		{ import = "plugins.dap" },
		{ import = "plugins.extended" },
		{ import = "plugins.copilot" },
		{ import = "plugins.avante" },
		{ import = "plugins.mcp" },
		{ import = "plugins.cmp" },
		-- { import = "plugins.language-specifics" },
	},
	-- Configure lazy.nvim options
	ui = {
		border = "rounded",
	},
})
