local api = vim.api

-- Helper function to create a reusable augroup
local function create_augroup(name, autocmds)
	local group = api.nvim_create_augroup(name, { clear = true })
	for _, autocmd in ipairs(autocmds) do
		api.nvim_create_autocmd(autocmd.event, {
			group = group,
			pattern = autocmd.pattern,
			callback = autocmd.callback,
			desc = autocmd.desc,
		})
	end
end

-- ============================================================================
-- Filetype-Specific Indentation Rules
-- ============================================================================
create_augroup("FileTypeSettings", {
	-- 2 spaces for web dev, yaml, etc.
	{
		event = "FileType",
		pattern = { "html", "css", "javascript", "typescript", "tsx", "json", "yaml", "sql" },
		desc = "Set indent to 2 spaces",
		callback = function()
			vim.bo.shiftwidth = 2
			vim.bo.tabstop = 2
			vim.bo.softtabstop = 2
		end,
	},
	-- 4 spaces for C, Python, etc.
	{
		event = "FileType",
		pattern = { "c", "python", "sh", "ruby", "htmldjango", "go" },
		desc = "Set indent to 4 spaces",
		callback = function()
			vim.bo.shiftwidth = 4
			vim.bo.tabstop = 4
			vim.bo.softtabstop = 4
		end,
	},
	-- 8 spaces for assembly
	{
		event = "FileType",
		pattern = "nasm",
		desc = "Set indent to 8 spaces for asm",
		callback = function()
			vim.bo.shiftwidth = 8
			vim.bo.tabstop = 8
			vim.bo.softtabstop = 8
		end,
	},
	-- Use real tabs for specific filetypes if desired
	{
		event = "FileType",
		pattern = { "c", "go", "make" },
		desc = "Use real tabs",
		callback = function()
			vim.bo.expandtab = false
		end,
	},
})

-- ============================================================================
-- Quality of Life Autocommands
-- ============================================================================
create_augroup("GeneralAutocmds", {
	-- Highlight the text you just pasted
	{
		event = "TextYankPost",
		pattern = "*",
		desc = "Highlight yanked text",
		callback = function()
			vim.hl.on_yank({ timeout = 200 })
		end,
	},
	-- Remove trailing whitespace on save
	{
		event = "BufWritePre",
		pattern = "*",
		desc = "Remove trailing whitespace on save",
		callback = function()
			local save_cursor = vim.fn.getpos(".")
			vim.cmd([[%s/\s\+$//e]])
			vim.fn.setpos(".", save_cursor)
		end,
	},
})

-- ============================================================================
-- Diagnostic Hover
-- ============================================================================
-- This autocommand will automatically open the diagnostic float window
-- when the cursor rests on a line with an error or warning.
create_augroup("DiagnosticHover", {
	{
		event = "CursorHold",
		pattern = "*",
		desc = "Show diagnostic popup on hover",
		callback = function()
			vim.diagnostic.open_float(nil, {
				focus = false, -- Don't steal focus from the editor
				scope = "cursor",
			})
		end,
	},
})

-- ============================================================================
-- Session Management with Obsession
-- ============================================================================
create_augroup("UnifiedSession", {
	{
		event = "VimEnter",
		pattern = "*",
		desc = "Auto-load or start Obsession session in workspace",
		callback = function()
			local session = vim.fn.getcwd() .. "/Session.vim"
			vim.schedule(function()
				if vim.fn.filereadable(session) == 1 then
					vim.cmd("source " .. session)
				end
				if vim.fn.exists("g:this_session") == 0 then
					vim.cmd("Obsession")
				end
			end)
		end,
	},
})

-- ============================================================================
-- CopilotChat Session Management
-- ============================================================================
create_augroup("CopilotChatSession", {
	{
		event = "VimLeavePre",
		pattern = "*",
		desc = "Auto-save CopilotChat session (workspace-specific)",
		callback = function()
			local workspace = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			local ok, _ = pcall(vim.cmd, "CopilotChatSave " .. workspace)
			if not ok then
				-- Silently ignore if CopilotChat is not loaded or no active chat
			end
		end,
	},
	-- Auto-restore chat on startup (after plugins are loaded)
	{
		event = "VimEnter",
		pattern = "*",
		desc = "Auto-restore CopilotChat session (workspace-specific)",
		callback = function()
			local workspace = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			-- Delay to ensure plugins are loaded
			vim.defer_fn(function()
				local ok, _ = pcall(vim.cmd, "CopilotChatLoad " .. workspace)
				if not ok then
					-- Silently ignore if no saved chat exists or CopilotChat is not available
				end
			end, 500) -- 500ms delay
		end,
	},
})
