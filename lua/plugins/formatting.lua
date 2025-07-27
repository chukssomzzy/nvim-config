return {
	-- Formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },

				python = { "isort", "black" },

				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				bash = { "shfmt" },
				dockerfile = { "prettier" },
			},

			format_on_save = {
				timeout_ms = 1500,
				lsp_fallback = true,
			},
		},
	},

	-- Linter
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost" },
		config = function()
			local lint = require("lint")
			local flake8 = lint.linters.flake8

			flake8.args = { "--max-line-length=88", "--ignore=E501,W503", "-" }

			lint.linters_by_ft = {
				python = { "flake8" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				bash = { "shellcheck" },
			}

			-- Set up linting to run only on save.
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = vim.api.nvim_create_augroup("LintAutocmd", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
