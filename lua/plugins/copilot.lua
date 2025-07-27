return {
	-- The core Copilot plugin for completions
	{
		"github/copilot.vim",
	},

	-- The new Copilot Chat plugin
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary", -- Use the canary branch for the latest features
		dependencies = {
			-- These are required dependencies
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" }, -- For file/buffer selection
		},
		-- The build command is required to compile the tokenizer
		build = "make | make tiktoken",
		config = function()
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			local telescope = require("telescope.builtin")
			
			-- Setup CopilotChat
			chat.setup({
				-- You can customize the chat window here
				window = {
					layout = "vertical",
					width = 0.5, -- 50% of the screen width
					height = 0.9,
				},
				mappings = {
					submit_prompt = {
						normal = "<Leader>s",
						insert = "<C-s>",
					},
					show_diff = {
						full_diff = true,
					},
				},
			})

			-- Helper function to insert context reference at cursor
			local function insert_context_reference(ref_type, content)
				local current_line = vim.api.nvim_get_current_line()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local col = cursor_pos[2]
				
				local new_line = current_line:sub(1, col) .. ref_type .. content .. " " .. current_line:sub(col + 1)
				vim.api.nvim_set_current_line(new_line)
				
				-- Move cursor to after the inserted reference
				local new_col = col + #ref_type + #content + 1
				vim.api.nvim_win_set_cursor(0, {cursor_pos[1], new_col})
			end

			-- Telescope integration for buffer selection
			local function telescope_insert_buffer_reference()
				telescope.buffers({
					attach_mappings = function(_, map)
						map("i", "<CR>", function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							require("telescope.actions").close(prompt_bufnr)
							if selection then
								local buf_name = vim.fn.fnamemodify(selection.filename or selection.display, ":t")
								insert_context_reference("#buffer:", buf_name)
							end
						end)
						return true
					end,
				})
			end

			-- Telescope integration for file selection
			local function telescope_insert_file_reference()
				telescope.find_files({
					attach_mappings = function(_, map)
						map("i", "<CR>", function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							require("telescope.actions").close(prompt_bufnr)
							if selection then
								insert_context_reference("#file:", selection.filename or selection.value)
							end
						end)
						return true
					end,
				})
			end

			-- Telescope integration for files pattern reference
			local function telescope_insert_files_reference()
				vim.ui.input({ prompt = "Enter file pattern: " }, function(pattern)
					if pattern and pattern ~= "" then
						insert_context_reference("#files:", pattern)
					end
				end)
			end

			-- Set up buffer-specific keymaps and completion for CopilotChat
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "copilot-chat",
				callback = function(args)
					local bufnr = args.buf
					local opts = { buffer = bufnr, noremap = true, silent = true }
					
					-- Insert mode keymaps for context references
					vim.keymap.set("i", "<C-x><C-b>", telescope_insert_buffer_reference, opts)
					vim.keymap.set("i", "<C-x><C-f>", telescope_insert_file_reference, opts)
					vim.keymap.set("i", "<C-x><C-g>", telescope_insert_files_reference, opts)
					
					-- Normal mode keymaps for context references
					vim.keymap.set("n", "<leader>cb", function()
						vim.cmd("startinsert")
						telescope_insert_buffer_reference()
					end, opts)
					vim.keymap.set("n", "<leader>cf", function()
						vim.cmd("startinsert")
						telescope_insert_file_reference()
					end, opts)

					-- Set up completion for CopilotChat buffer
					local ok, cmp = pcall(require, "cmp")
					if ok then
						cmp.setup.buffer({
							sources = cmp.config.sources({
								{ name = "copilotchat-context" },
								{ name = "buffer" },
								{ name = "path" },
							}),
						})
					end
				end,
			})

			-- Global keymaps for CopilotChat functions
			local opts = { noremap = true, silent = true }
			
			-- Chat commands
			vim.keymap.set({"n", "v"}, "<leader>cc", "<cmd>CopilotChat<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>ce", "<cmd>CopilotChatExplain<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>cr", "<cmd>CopilotChatReview<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>cf", "<cmd>CopilotChatFix<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>co", "<cmd>CopilotChatOptimize<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>cd", "<cmd>CopilotChatDocs<CR>", opts)
			vim.keymap.set({"n", "v"}, "<leader>ct", "<cmd>CopilotChatTests<CR>", opts)
			
			-- Toggle and reset
			vim.keymap.set("n", "<leader>cq", "<cmd>CopilotChatClose<CR>", opts)
			vim.keymap.set("n", "<leader>cR", "<cmd>CopilotChatReset<CR>", opts)
		end,
	},
}
