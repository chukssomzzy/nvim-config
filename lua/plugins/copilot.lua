return {
	-- The core Copilot plugin for completions
	{
		"github/copilot.vim",
	},

	-- The new Copilot Chat plugin with enhanced features
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary", -- Use canary branch for latest features
		dependencies = {
			-- These are required dependencies
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" }, -- Add telescope dependency
		},
		-- The build command is required to compile the tokenizer
		build = "make tiktoken",
		config = function()
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			
			-- Setup CopilotChat with enhanced configuration
			chat.setup({
				window = {
					layout = "vertical",
					width = 0.5,
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

			-- Helper function to insert context reference with telescope
			local function insert_context_reference(ref_type)
				local telescope = require("telescope.builtin")
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				
				local function insert_reference(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					
					if selection then
						local ref_text
						if ref_type == "buffer" then
							ref_text = "#buffer:" .. selection.filename
						elseif ref_type == "file" then
							ref_text = "#file:" .. selection.path
						elseif ref_type == "files" then
							ref_text = "#files:" .. selection.value
						end
						
						-- Insert the reference at cursor position
						if ref_text then
							local row, col = unpack(vim.api.nvim_win_get_cursor(0))
							vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { ref_text })
							-- Move cursor to end of inserted text
							vim.api.nvim_win_set_cursor(0, { row, col + #ref_text })
						end
					end
				end

				if ref_type == "buffer" then
					telescope.buffers({
						attach_mappings = function(_, map)
							map("i", "<CR>", insert_reference)
							map("n", "<CR>", insert_reference)
							return true
						end,
					})
				elseif ref_type == "file" then
					telescope.find_files({
						attach_mappings = function(_, map)
							map("i", "<CR>", insert_reference)
							map("n", "<CR>", insert_reference)
							return true
						end,
					})
				elseif ref_type == "files" then
					telescope.live_grep({
						attach_mappings = function(_, map)
							map("i", "<CR>", insert_reference)
							map("n", "<CR>", insert_reference)
							return true
						end,
					})
				end
			end

			-- Set buffer-specific keymaps for copilot-chat buffers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "copilot-chat",
				callback = function(event)
					local opts = { buffer = event.buf, silent = true }
					
					-- Insert mode telescope integration
					vim.keymap.set("i", "<C-x><C-b>", function()
						insert_context_reference("buffer")
					end, vim.tbl_extend("force", opts, { desc = "Insert buffer reference via Telescope" }))
					
					vim.keymap.set("i", "<C-x><C-f>", function()
						insert_context_reference("file")
					end, vim.tbl_extend("force", opts, { desc = "Insert file reference via Telescope" }))
					
					vim.keymap.set("i", "<C-x><C-g>", function()
						insert_context_reference("files")
					end, vim.tbl_extend("force", opts, { desc = "Insert files reference via Telescope" }))
				end,
			})

			-- Global keymaps for context reference insertion
			vim.keymap.set("n", "<leader>cb", function()
				insert_context_reference("buffer")
			end, { desc = "Insert buffer reference" })
			
			vim.keymap.set("n", "<leader>cf", function()
				insert_context_reference("file")
			end, { desc = "Insert file reference" })

			-- Enhanced CopilotChat command keymaps
			vim.keymap.set("n", "<leader>coq", function()
				chat.ask(vim.fn.input("Quick Chat: "), { selection = select.buffer })
			end, { desc = "CopilotChat - Quick chat with buffer" })

			vim.keymap.set("n", "<leader>coo", "<cmd>CopilotChatOpen<cr>", { desc = "CopilotChat - Open chat" })
			vim.keymap.set("n", "<leader>cot", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat - Toggle chat" })
			
			vim.keymap.set("n", "<leader>cop", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end, { desc = "CopilotChat - Prompt actions" })
			
			vim.keymap.set("n", "<leader>coh", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			end, { desc = "CopilotChat - Help actions" })

			-- Code-specific commands
			vim.keymap.set({ "n", "v" }, "<leader>coe", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat - Explain code" })
			vim.keymap.set({ "n", "v" }, "<leader>cor", "<cmd>CopilotChatReview<cr>", { desc = "CopilotChat - Review code" })
			vim.keymap.set({ "n", "v" }, "<leader>cof", "<cmd>CopilotChatFix<cr>", { desc = "CopilotChat - Fix code" })
			vim.keymap.set({ "n", "v" }, "<leader>cod", "<cmd>CopilotChatOptimize<cr>", { desc = "CopilotChat - Optimize code" })
			vim.keymap.set({ "n", "v" }, "<leader>com", "<cmd>CopilotChatDocs<cr>", { desc = "CopilotChat - Generate docs" })
			vim.keymap.set({ "n", "v" }, "<leader>cos", "<cmd>CopilotChatTests<cr>", { desc = "CopilotChat - Generate tests" })

			-- Git integration
			vim.keymap.set("n", "<leader>cog", "<cmd>CopilotChatCommit<cr>", { desc = "CopilotChat - Generate commit message" })
		end,
	},
}
