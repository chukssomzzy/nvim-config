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

-- ============================================================================
-- Snacks Terminal Keymappings
-- ============================================================================

-- Primary terminal commands with <leader>t prefix
map("n", "<leader>tt", function()
	Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

map("n", "<leader>tf", function()
	Snacks.terminal.toggle(nil, { win = { position = "float" } })
end, { desc = "Toggle floating terminal" })

map("n", "<leader>th", function()
	Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.4 } })
end, { desc = "Toggle horizontal terminal" })

map("n", "<leader>tv", function()
	Snacks.terminal.toggle(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Toggle vertical terminal" })

-- Specialized terminal environments

map("n", "<leader>tp", function()
	Snacks.terminal.toggle("python3", {
		win = { position = "float", width = 0.8, height = 0.6 },
		interactive = true,
	})
end, { desc = "Toggle Python REPL" })

map("n", "<leader>tn", function()
	Snacks.terminal.toggle("node", {
		win = { position = "float", width = 0.8, height = 0.6 },
		interactive = true,
	})
end, { desc = "Toggle Node.js REPL" })

-- Terminal management
map("n", "<leader>tl", function()
	local terminals = Snacks.terminal.list()
	if #terminals > 0 then
		vim.ui.select(terminals, {
			prompt = "Select Terminal:",
			format_item = function(term)
				return string.format("[%s] %s", term.id or "?", term.cmd or "shell")
			end,
		}, function(choice)
			if choice then
				choice:show()
			end
		end)
	else
		vim.notify("No terminals found", vim.log.levels.INFO)
	end
end, { desc = "List and select terminals" })

map("n", "<leader>tk", function()
	local terminals = Snacks.terminal.list()
	for _, term in ipairs(terminals) do
		term:close()
	end
	vim.notify("Closed all terminals", vim.log.levels.INFO)
end, { desc = "Kill all terminals" })

-- Quick access terminal commands
map("n", "<leader>tc", function()
	Snacks.terminal.toggle(nil, {
		cwd = vim.fn.getcwd(),
		win = { position = "float" },
	})
end, { desc = "Open new terminal in current directory" })

map("n", "<leader>tr", function()
	Snacks.terminal.open(nil, {
		cwd = vim.fn.expand("%:p:h"),
		win = { position = "bottom", height = 0.3 },
	})
end, { desc = "Open terminal in current file directory" })

-- Terminal mode keybindings
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to down window from terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to up window from terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window from terminal" })

-- Terminal resize keybindings (when in terminal window)
map("t", "<C-Up>", "<C-\\><C-n><cmd>resize +2<CR>a", { desc = "Increase terminal height" })
map("t", "<C-Down>", "<C-\\><C-n><cmd>resize -2<CR>a", { desc = "Decrease terminal height" })
map("t", "<C-Left>", "<C-\\><C-n><cmd>vertical resize -2<CR>a", { desc = "Decrease terminal width" })
map("t", "<C-Right>", "<C-\\><C-n><cmd>vertical resize +2<CR>a", { desc = "Increase terminal width" })

-- ============================================================================
-- Plugin Keymappings
-- ============================================================================

-- Toggle file explorer
map("n", "<leader>h", function()
	require("mini.files").open()
end, { desc = "Toggle file explorer (mini.files)" })

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
		vim.notify("README.md not found at: " .. readme_path, { level = "error" })
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
-- Session Management (vim-obsession)
-- ============================================================================
-- Start a new session with Obsession
map("n", "<leader>ss", "<cmd>Obsession<CR>", { desc = "Start Obsession session" })
-- Stop the current session
map("n", "<leader>se", "<cmd>Obsession!<CR>", { desc = "End Obsession session" })
-- Reload the last session (if available)
map("n", "<leader>sr", "<cmd>source Session.vim<CR>", { desc = "Reload last session" })

-- ============================================================================
-- AI & Code Assistance Keymappings
-- ============================================================================

-- Avante.nvim - AI coding assistant with explicit mode
map("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Ask Avante AI" })
map("n", "<leader>af", "<cmd>AventeFastApply<CR>", { desc = "Apply AI suggestion with confirmation" })
map("n", "<leader>ap", "<cmd>AventePreview<CR>", { desc = "Preview AI suggestion safely" })
map("n", "<leader>ae", "<cmd>AventeExplicitApply<CR>", { desc = "Apply with explicit context confirmation" })
map("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Toggle Avante panel" })

-- Context management for Avante
map("n", "<leader>cf", function()
	-- Add file to Avante context using telescope
	require("telescope.builtin").find_files({
		prompt_title = "Add File to Avante Context",
		attach_mappings = function(_, map_key)
			map_key("i", "<CR>", function(prompt_bufnr)
				local selection = require("telescope.actions.state").get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				if selection then
					-- Add file to Avante context
					vim.cmd("AvanteEdit " .. selection.path)
					require("snacks").notify(
						"📁 Added file to Avante context: " .. selection.filename,
						{ level = "info" }
					)
				end
			end)
			return true
		end,
	})
end, { desc = "Add file to Avante context" })

map("n", "<leader>cb", function()
	-- Add current buffer to Avante context
	local buf_name = vim.api.nvim_buf_get_name(0)
	if buf_name and buf_name ~= "" then
		local filename = vim.fn.fnamemodify(buf_name, ":t")
		-- Use Avante's buffer integration
		vim.cmd("AvanteEdit")
		require("snacks").notify("📄 Added current buffer to Avante context: " .. filename, { level = "info" })
	else
		require("snacks").notify("❌ Cannot add unnamed buffer to context", { level = "warn" })
	end
end, { desc = "Add current buffer to Avante context" })

-- Combined CopilotChat + Avante workflow
map("n", "<leader>ca", function()
	vim.cmd("CopilotChatOpen")
	vim.defer_fn(function()
		vim.cmd("AvanteToggle")
	end, 100)
	require("snacks").notify("🤖 Opened combined AI workflow: CopilotChat + Avante", { level = "info" })
end, { desc = "Open combined CopilotChat + Avante" })
map("v", "<leader>cc", ":CopilotChat<CR>", { desc = "Send selection to CopilotChat" })

-- ============================================================================
-- Mini.jump2d Keymappings
-- ============================================================================

-- Primary jump commands under <leader>j prefix
map("n", "<leader>jj", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.default)
end, { desc = "Jump: Default jump (smart spotter)" })

map("n", "<leader>jl", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.line_start)
end, { desc = "Jump: Line start" })

map("n", "<leader>jw", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.word_start)
end, { desc = "Jump: Word start" })

map("n", "<leader>jc", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.single_character)
end, { desc = "Jump: Single character (user input)" })

map("n", "<leader>jq", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.query)
end, { desc = "Jump: Query (user input)" })

-- Enhanced jump options with visual preview
map("n", "<leader>jp", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").gen_spotter.pattern("%p+"),
		allowed_lines = { cursor_before = true, cursor_at = true, cursor_after = true },
		view = { n_steps_ahead = 1, dim = true },
	})
end, { desc = "Jump: Punctuation marks" })

-- Jump within current window only
map("n", "<leader>jn", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").builtin_opts.default.spotter,
		allowed_windows = { current = true, not_current = false },
		view = { dim = true },
	})
end, { desc = "Jump: Current window only" })

-- Jump forward/backward only
map("n", "<leader>jf", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").builtin_opts.default.spotter,
		allowed_lines = { cursor_before = false, cursor_at = true, cursor_after = true },
		view = { dim = true },
	})
end, { desc = "Jump: Forward only" })

map("n", "<leader>jb", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").builtin_opts.default.spotter,
		allowed_lines = { cursor_before = true, cursor_at = true, cursor_after = false },
		view = { dim = true },
	})
end, { desc = "Jump: Backward only" })

-- Advanced jump patterns
map("n", "<leader>jv", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").builtin_opts.word_start.spotter,
		view = { n_steps_ahead = 2, dim = true },
		labels = "abcdefghijklmnopqrstuvwxyz",
	})
end, { desc = "Jump: Word start with visual preview" })

-- Jump to specific patterns
map("n", "<leader>j.", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").gen_spotter.pattern("%."),
		view = { dim = true },
	})
end, { desc = "Jump: To dots/periods" })

map("n", "<leader>j,", function()
	require("mini.jump2d").start({
		spotter = require("mini.jump2d").gen_spotter.pattern("[,;]"),
		view = { dim = true },
	})
end, { desc = "Jump: To commas/semicolons" })

-- LSP keybindings
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
