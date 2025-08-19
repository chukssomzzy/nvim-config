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
					-- recommended settings for Avante.nvim integration
					default = {
						embed_image_as_base64 = true, -- Enable base64 embedding for Avante
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
						-- Process images for AI analysis
						process_cmd = "convert $FILENAME -resize 800x600> $FILENAME",
						-- Template for image insertion in Avante context
						template = "![Image]($FILE_PATH)",
					},
					-- Specific configuration for Avante filetypes
					filetypes = {
						Avante = {
							-- Enhanced template for Avante AI context
							template = "I'm sharing an image for analysis:\n\n![Image for AI Analysis]($FILE_PATH)\n\nPlease analyze this image and provide insights.",
							drag_and_drop = {
								insert_mode = true,
								copy_images = true,
							},
						},
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
				auto_suggestions = false, -- Disable automatic suggestions for explicit control
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
					auto_suggestions = false, -- Disable automatic suggestions - require explicit activation
					auto_set_highlight_group = true,
					auto_set_keymaps = true,
					auto_apply_diff_after_generation = false, -- Always require manual confirmation
					support_paste_from_clipboard = true, -- Enable clipboard support for images
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
					-- Enhanced paste mapping for images
					paste = {
						normal = "p", -- Use 'p' for pasting images with proper formatting
						insert = "<C-v>", -- Alternative paste in insert mode
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

			-- Custom functions for enhanced explicit apply workflow
			local avante_utils = {}
			
			-- Fast apply with explicit confirmation for maximum safety
			function avante_utils.fast_apply_with_confirm()
				-- Show detailed confirmation dialog
				local choice = vim.fn.confirm(
					"Apply AI suggestion to current cursor position?\n" ..
					"⚠️  This will modify your code. Review the suggestion first.",
					"&Apply\n&Cancel\n&Preview First", 
					2 -- Default to Cancel for safety
				)
				if choice == 1 then
					require("avante.api").apply_cursor()
					require("snacks").notify("✅ AI suggestion applied successfully", { level = "info" })
				elseif choice == 3 then
					-- Show diff preview without applying
					vim.cmd("AvanteEdit")
					require("snacks").notify("📋 Preview opened - review before applying", { level = "info" })
				else
					require("snacks").notify("❌ Apply cancelled by user", { level = "info" })
				end
			end
			
			-- Explicit apply with context confirmation - no automatic application
			function avante_utils.explicit_apply()
				local buf = vim.api.nvim_get_current_buf()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local line = vim.api.nvim_buf_get_lines(buf, cursor_pos[1]-1, cursor_pos[1], false)[1]
				
				-- Always require explicit confirmation regardless of context
				local context_info = line and #line > 0 and 
					string.format("Line %d: %s", cursor_pos[1], line:sub(1, 50)) or
					"Empty line"
				
				local choice = vim.fn.confirm(
					"Apply AI suggestion at cursor position?\n\n" ..
					"Context: " .. context_info .. "\n\n" ..
					"⚠️  This action will modify your code.",
					"&Apply\n&Cancel\n&Show Preview", 
					2 -- Default to Cancel
				)
				
				if choice == 1 then
					require("avante.api").apply_cursor()
					require("snacks").notify("🤖 AI suggestion applied at cursor", { level = "info" })
				elseif choice == 3 then
					vim.cmd("AvanteEdit")
					require("snacks").notify("📋 Preview opened for review", { level = "info" })
				else
					require("snacks").notify("❌ Apply cancelled", { level = "info" })
				end
			end

			-- Safe preview function that never auto-applies
			function avante_utils.preview_suggestion()
				vim.cmd("AvanteEdit")
				require("snacks").notify("📋 Suggestion preview opened - use manual apply when ready", { level = "info" })
			end

			-- Create user commands for explicit control
			vim.api.nvim_create_user_command("AventeFastApply", avante_utils.fast_apply_with_confirm, {
				desc = "Apply AI suggestion with explicit confirmation and safety checks"
			})
			
			vim.api.nvim_create_user_command("AventeExplicitApply", avante_utils.explicit_apply, {
				desc = "Apply AI suggestion with context confirmation (replaces smart apply)"
			})

			vim.api.nvim_create_user_command("AventePreview", avante_utils.preview_suggestion, {
				desc = "Preview AI suggestion without applying (safe preview)"
			})

			-- Remove the old smart apply command to prevent confusion
			-- AventeSmartApply has been replaced with AventeExplicitApply for safety

			-- Set up autocmds for better integration
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "Avante",
				callback = function(event)
					local opts = { buffer = event.buf, silent = true }
					-- Buffer-specific keymaps for Avante windows
					vim.keymap.set("n", "q", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Close Avante window" }))
					vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Close Avante window" }))
					
					-- Disable problematic autocmds that might conflict with Avante
					vim.b[event.buf].copilot_enabled = false -- Disable Copilot suggestions in Avante buffer
					
					-- Set buffer options for better Avante experience
					vim.bo[event.buf].spell = false -- Disable spell check in Avante buffer
					vim.bo[event.buf].wrap = true -- Enable word wrap for better readability
				end,
			})

			-- Prevent conflicts with other plugins when in Avante buffer
			vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
				pattern = "*",
				callback = function()
					-- Skip processing if we're in an Avante buffer to prevent conflicts
					if vim.bo.filetype == "Avante" then
						return
					end
					-- Allow normal processing for other filetypes
				end,
			})
		end,
	},
}