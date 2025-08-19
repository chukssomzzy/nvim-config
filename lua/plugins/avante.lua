return {
	-- Avante.nvim - AI-powered coding assistant with fast apply functionality
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			instructions_file = ".avante/avante.md",
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
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
				disabled_tools = {
					"list_files", -- Built-in file operations
					"search_files",
					"read_file",
					"create_file",
					"rename_file",
					"delete_file",
					"create_dir",
					"rename_dir",
					"delete_dir",
					"bash", -- Built-in terminal access
				},
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
					support_paste_from_clipboard = false, -- Enable clipboard support for images
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
					--@type AvanteConflictHighlights
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
				system_prompt = function()
					local hub = require("mcphub").get_hub_instance()
					return hub and hub:get_active_servers_prompt() or ""
				end,
				-- Using function prevents requiring mcphub before it's loaded
				custom_tools = function()
					return {
						require("mcphub.extensions.avante").mcp_tool(),
					}
				end,
			})
		end,
	},
}
