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
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

			-- Keybindings to be attached to each LSP server.
			local on_attach = function(_, bufnr)
				local map = vim.keymap.set
				map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
				map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: Go to Declaration" })
				map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
				map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to Implementation" })
				map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP: Signature Help" })
				map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: Show References" })
				map("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
				map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
			end

			-- Configure diagnostic signs and floating window border.
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				float = { border = "rounded" },
			})

			-- Add a border to the hover popups.
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			-- Instead of `setup_handlers`, we manually loop through the server list.
			for _, server_name in ipairs(servers) do
				lspconfig[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
		end,
	},
}
