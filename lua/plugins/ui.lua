return {
	{
		"folke/edgy.nvim",
		---@module 'edgy'
		---@param opts Edgy.Config
		opts = function(_, opts)
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				opts[pos] = opts[pos] or {}
				table.insert(opts[pos], {
					ft = "snacks_terminal",
					size = { height = 0.4 },
					title = "%{b:snacks_terminal.id}: %{b:term_title}",
					filter = function(_buf, win)
						return vim.w[win].snacks_win
							and vim.w[win].snacks_win.position == pos
							and vim.w[win].snacks_win.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				})
			end
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({ style = "night" })
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	-- animate the animatable
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.animate").setup()
			require("mini.indentscope").setup()
			require("mini.pairs").setup()
			require("mini.comment").setup()
			require("mini.files").setup()
			require("mini.diff").setup()
			require("mini.tabline").setup()
			require("mini.jump2d").setup({
				allowed_lines = { cursor_before = true },
				allowed_windows = { not_current = true },
				view = {
					dim = false,
				},
			})
			-- Add more modules as needed
		end,
	},
	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = "|",
					section_separators = "",
					icons_enabled = true,
				},
				sections = {
					lualine_c = { "filename" },
					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
						{
							function()
								-- Check if MCPHub is loaded
								if not vim.g.loaded_mcphub then
									return "󰐻 -"
								end

								local count = vim.g.mcphub_servers_count or 0
								local status = vim.g.mcphub_status or "stopped"
								local executing = vim.g.mcphub_executing

								-- Show "-" when stopped
								if status == "stopped" then
									return "󰐻 -"
								end

								-- Show spinner when executing, starting, or restarting
								if executing or status == "starting" or status == "restarting" then
									local frames =
										{ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
									local frame = math.floor(vim.loop.now() / 100) % #frames + 1
									return "󰐻 " .. frames[frame]
								end

								return "󰐻 " .. count
							end,
							color = function()
								if not vim.g.loaded_mcphub then
									return { fg = "#6c7086" } -- Gray for not loaded
								end

								local status = vim.g.mcphub_status or "stopped"
								if status == "ready" or status == "restarted" then
									return { fg = "#50fa7b" } -- Green for connected
								elseif status == "starting" or status == "restarting" then
									return { fg = "#ffb86c" } -- Orange for connecting
								else
									return { fg = "#ff5555" } -- Red for error/stopped
								end
							end,
						},
					},
				},
			})
		end,
	},

	-- Git signs in the sign column
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Snacks.nvim - Modern notification system with UI enhancements
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Configure notifications
			notifier = {
				enabled = true,
				top_down = false,
				style = "fancy",
				margin = { top = 0, right = 1, bottom = 0 },
				width = { min = 40, max = 0.4 },
				height = { min = 1, max = 0.6 },
			},
			-- Enable input/select UI enhancements
			input = { enabled = true },
			select = { enabled = true },

			-- Add dashboard for image support
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},

			image = {
				enabled = true,
			},
			-- Enable bigfile for better performance with large files
			bigfile = { enabled = true },

			-- Enable quickfile for faster file operations
			quickfile = { enabled = true },

			-- Enable statuscolumn improvements
			statuscolumn = { enabled = true },

			terminal = {
				-- Default window configuration
				win = {
					style = "terminal",
					-- Enhanced terminal window settings
					wo = {
						winbar = "%{b:snacks_terminal.id}: %{b:term_title}",
						statuscolumn = "",
						number = false,
						relativenumber = false,
					},
				},
				-- Buffer options for terminal
				bo = {
					filetype = "snacks_terminal",
					bufhidden = "hide",
					buflisted = false,
				},
				-- Default behavior settings
				interactive = true, -- Auto-insert, auto-close, start-insert
				auto_insert = true, -- Enter insert mode when entering terminal
				auto_close = true, -- Close terminal when process exits
				start_insert = true, -- Start in insert mode
				-- Environment variables for terminals
				env = {
					TERM = "xterm-256color",
				},
				-- Terminal keybindings
				keys = {
					q = "hide",
					-- Enhanced file navigation under cursor
					gf = function(self)
						local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
						if f == "" then
							Snacks.notify.warn("No file under cursor")
						else
							self:hide()
							vim.schedule(function()
								vim.cmd("e " .. f)
							end)
						end
					end,
					-- Improved escape handling
					term_normal = {
						"<esc>",
						function(self)
							self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
							if self.esc_timer:is_active() then
								self.esc_timer:stop()
								vim.cmd("stopinsert")
							else
								self.esc_timer:start(200, 0, function() end)
								return "<esc>"
							end
						end,
						mode = "t",
						expr = true,
						desc = "Double escape to normal mode",
					},
					-- Navigation between terminals
					["<C-h>"] = function(self)
						self:hide()
						vim.cmd("wincmd h")
					end,
					["<C-j>"] = function(self)
						self:hide()
						vim.cmd("wincmd j")
					end,
					["<C-k>"] = function(self)
						self:hide()
						vim.cmd("wincmd k")
					end,
					["<C-l>"] = function(self)
						self:hide()
						vim.cmd("wincmd l")
					end,
				},
			},

			-- Enable words (better word under cursor highlighting)
			words = { enabled = true },
		},
	},
}
