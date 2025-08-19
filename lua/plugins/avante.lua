return {
	-- Avante.nvim - AI-powered coding assistant with fast apply functionality
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			-- add any opts here
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		config = function()
			require("avante").setup({
				-- Provider configuration for AI services
				provider = "copilot", -- Use GitHub Copilot as the primary provider
				auto_suggestions = true, -- Enable automatic suggestions
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "gpt-4o-2024-05-13",
					proxy = nil, -- [protocol://]host[:port] Use this proxy
					allow_insecure = false, -- Allow insecure server connections
					timeout = 30000, -- Timeout in milliseconds
					temperature = 0, -- Lower temperature for more accurate suggestions
					max_tokens = 4096,
				},
				behaviour = {
					auto_suggestions = true, -- Experimental stage
					auto_set_highlight_group = true,
					auto_set_keymaps = true,
					auto_apply_diff_after_generation = false, -- Manual control for accuracy
					support_paste_from_clipboard = false,
				},
				mappings = {
					--- @class AvanteConflictMappings
					diff = {
						ours = "co",
						theirs = "ct",
						all_theirs = "ca",
						both = "cb",
						cursor = "cc",
						next = "]x",
						prev = "[x",
					},
					suggestion = {
						accept = "<M-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
					jump = {
						next = "]]",
						prev = "[[",
					},
					submit = {
						normal = "<CR>",
						insert = "<C-s>",
					},
					sidebar = {
						apply_all = "A",
						apply_cursor = "a",
						switch_windows = "<Tab>",
						reverse_switch_windows = "<S-Tab>",
					},
				},
				hints = { enabled = true },
				windows = {
					---@type "right" | "left" | "top" | "bottom"
					position = "right", -- the position of the sidebar
					wrap = true, -- similar to vim.o.wrap
					width = 30, -- default % based on available width
					sidebar_header = {
						align = "center", -- left, center, right for title
						rounded = true,
					},
					input = {
						prefix = "> ",
						height = 8, -- Height of the input window in VIM lines
					},
					edit = {
						border = "rounded",
						start_insert = true, -- Start insert mode when opening the edit window
					},
					ask = {
						floating = false, -- Open the 'AvanteAsk' prompt in a floating window
						start_insert = true, -- Start insert mode when opening the ask window
						border = "rounded",
						---@type "ours" | "theirs"
						focus_on_apply = "ours", -- which diff to focus after applying
					},
				},
				highlights = {
					---@type AvanteConflictHighlights
					diff = {
						current = "DiffText",
						incoming = "DiffAdd",
					},
				},
				--- @class AvanteConflictUserConfig
				diff = {
					autojump = true,
					---@type string | fun(): string
					list_opener = "copen",
					--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen)
					--- Helps to avoid entering operator-pending mode with diff mappings
					override_timeoutlen = 500,
				},
			})

			-- Custom functions for enhanced fast apply workflow
			local avante_utils = {}
			
			-- Fast apply with confirmation for high accuracy
			function avante_utils.fast_apply_with_confirm()
				local choice = vim.fn.confirm("Apply AI suggestion?", "&Yes\n&No\n&Preview", 1)
				if choice == 1 then
					require("avante.api").apply_cursor()
					require("snacks").notify("✅ Applied AI suggestion", { level = "info" })
				elseif choice == 3 then
					-- Show diff preview
					vim.cmd("AvanteEdit")
				end
			end
			
			-- Smart apply - automatically detects context and applies appropriate suggestion
			function avante_utils.smart_apply()
				local buf = vim.api.nvim_get_current_buf()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local line = vim.api.nvim_buf_get_lines(buf, cursor_pos[1]-1, cursor_pos[1], false)[1]
				
				-- Check if we're in a context where applying makes sense
				if line and #line > 0 then
					require("avante.api").apply_cursor()
					require("snacks").notify("🤖 Smart apply completed", { level = "info" })
				else
					require("snacks").notify("⚠️  No valid context for smart apply", { level = "warn" })
				end
			end

			-- Create user commands for easy access
			vim.api.nvim_create_user_command("AventeFastApply", avante_utils.fast_apply_with_confirm, {
				desc = "Fast apply with confirmation for high accuracy"
			})
			
			vim.api.nvim_create_user_command("AventeSmartApply", avante_utils.smart_apply, {
				desc = "Smart apply based on context"
			})

			-- Set up autocmds for better integration
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "Avante",
				callback = function(event)
					local opts = { buffer = event.buf, silent = true }
					-- Buffer-specific keymaps for Avante windows
					vim.keymap.set("n", "q", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Close Avante window" }))
					vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Close Avante window" }))
				end,
			})
		end,
	},
}