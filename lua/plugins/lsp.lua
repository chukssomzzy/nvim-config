return {
	-- First, set up Mason itself.
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- This is the bridge between Mason and the LSP client.
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
	},

	-- Finally, configure the LSP client itself.
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			-- The list of servers you want Mason to install.
			local servers = {
				"pyright",
				"html",
				"cssls",
				"tailwindcss",
				"eslint",
				"bashls",
				"rust_analyzer",
				"lua_ls",
				"vimls",
				"yamlls",
				"jsonls",
				"dockerls",
			}
			-- This ensures the servers are installed by Mason.
			mason_lspconfig.setup({ ensure_installed = servers })

			-- Configure diagnostic signs and floating window border.
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				float = { border = "rounded" },
			})

			-- Add a border to the hover popups.
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		end,
	},
}
