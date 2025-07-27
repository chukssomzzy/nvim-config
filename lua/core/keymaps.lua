local map = vim.keymap.set

-- Insert Mode convenience: jk to <esc>
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Clear search highlight on <Esc>
--[[ map("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
]]
map("n", "<F2>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle line wrap" })

-- File and buffer management
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Line moving
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Terminal
map("n", "<leader>tt", "<cmd>new --size=10 | terminal<CR>", { desc = "Open horizontal terminal" })
map("n", "<leader>tv", "<cmd>vnew --size=40 | terminal<CR>", { desc = "Open vertical terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- ============================================================================
-- Plugin Keymappings
-- ============================================================================

-- Toggle NERDTree file explorer
map("n", "<leader>h", "<cmd>NERDTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Format the current buffer with conform.nvim
map({ "n", "v" }, "<leader>i", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- ============================================================================
-- Diagnostics Keymappings (The Fix)
-- ============================================================================
-- We use mnemonic keys that are unlikely to conflict with other plugins.

-- Show diagnostic popup for the current line
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Go to the previous diagnostic
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

-- Go to the next diagnostic
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- Git blame mappings
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git Blame selection" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git Diff this" })

-- ============================================================================
--Custom Functions & Mappings
-- ============================================================================

--- Smartly closes a buffer or quits Neovim if it's the last buffer.
local function smart_quit()
	local buflist = vim.fn.getbufinfo({ buflisted = 1 })
	if #buflist > 1 then
		vim.cmd("bdelete")
	else
		vim.cmd("quit")
	end
end

-- Map the new smart_quit function
map("n", "<leader>q", smart_quit, { desc = "Smart Quit (bdelete or quit)" })

--- Edit the Neovim configuration
local function edit_config()
	vim.cmd("e ~/.config/nvim/init.lua")
end

map("n", "<leader>ec", edit_config, { desc = "Edit Neovim Config" })

--- Force write the current buffer with sudo
local function sudo_write()
	vim.cmd("w !sudo tee % > /dev/null")
end

map("n", "<leader>sw", sudo_write, { desc = "Sudo Write" })

-- ============================================================================
-- Debugging (DAP) Keymappings
-- ============================================================================

-- DAP UI
map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

-- Breakpoints
map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set Conditional Breakpoint" })

-- Control Flow
map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue" })
map("n", "<leader>dj", function()
	require("dap").step_over()
end, { desc = "Step Over" })
map("n", "<leader>dk", function()
	require("dap").step_into()
end, { desc = "Step Into" })
map("n", "<leader>do", function()
	require("dap").step_out()
end, { desc = "Step Out" })
map("n", "<leader>dr", function()
	require("dap").repl.open()
end, { desc = "Open REPL" })
map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate Session" })

-- ============================================================================
-- View Config Documentation
-- ============================================================================

--- Opens a read-only floating window with the content of the README.md file.
local function show_config_help()
	local config_path = vim.fn.stdpath("config")
	local readme_path = config_path .. "/README.md"

	-- Use vim.loop.fs_stat to check if the file exists BEFORE trying to read it.
	-- This is more robust than checking for an error after a failed read.
	local stat = vim.loop.fs_stat(readme_path)
	if not stat then
		vim.notify("README.md not found at: " .. readme_path, vim.log.levels.ERROR)
		return
	end

	-- Read the file content into a table of lines
	local lines = vim.fn.readfile(readme_path)

	-- Create a new scratch buffer to display the help
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	-- Set buffer options to make it feel like a read-only help window
	vim.bo[bufnr].filetype = "markdown"
	vim.bo[bufnr].readonly = true
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "hide"
	vim.bo[bufnr].swapfile = false

	-- Calculate dimensions for a centered floating window
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Open the floating window
	vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- Add a keymap to close the floating window with 'q'
	-- This keymap is local to the new buffer we created.
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr, silent = true, nowait = true })
end

-- Map the keybinding to the new, robust function
map("n", "<leader>/", show_config_help, { desc = "Show Config Help (README.md)" })

-- ============================================================================
-- Telescope Keymappings
-- ===========================================================================

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP Document Symbols" })
map("n", "<leader>m", "<cmd>Telescope oldfiles<cr>", { desc = "Find old files" })
map("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Search Diagnostics" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Search Keymaps" })

-- ============================================================================
-- Copilot Chat Keymappings
-- ============================================================================

-- General Chat: Ask a question
-- Note the space at the end to allow you to type your question directly
map("n", "<leader>cc", "<cmd>CopilotChat<CR>", { desc = "Copilot - Chat" })

-- Visual Mode Chat: Ask about the selected code
map("v", "<leader>cc", ":'<,'>CopilotChat<CR>", { desc = "Copilot - Chat with selection" })

-- Quick Chat Toggle
map("n", "<leader>cq", "<cmd>CopilotChatToggle<CR>", { desc = "Copilot - Toggle Quick Chat" })

-- Common Chat Actions
map("n", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot - Explain code" })
map("n", "<leader>ct", "<cmd>CopilotChatTests<CR>", { desc = "Copilot - Generate tests" })
map("n", "<leader>cd", "<cmd>CopilotChatDocs<CR>", { desc = "Copilot - Generate docs" })
map("n", "<leader>co", "<cmd>CopilotChatOptimize<CR>", { desc = "Copilot - Optimize code" })
