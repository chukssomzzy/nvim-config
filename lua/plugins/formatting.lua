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
				javascript = { "eslint_d", "prettier" },
				typescript = { "eslint_d", "prettier" },
				javascriptreact = { "eslint_d", "prettier" },
				typescriptreact = { "eslint_d", "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				bash = { "shfmt" },
				dockerfile = { "prettier" },
				go = { "gofmt", "prettier" },
				php = { "pint" },
				blade = { "blade-formatter" },
			},

			format_on_save = {
				timeout_ms = 500,
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
			lint.linters.golangci_lint = {
				cmd = "golangci-lint",
				stdin = false,
				args = { "run", "--out-format", "json" },
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
					source = "golangci-lint",
					severity = vim.diagnostic.severity.WARN,
				}),
			}
			lint.linters_by_ft = {
				python = { "flake8" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				bash = { "shellcheck" },
				go = { "golangci_lint" },
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
