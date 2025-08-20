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

-- ============================================================================
-- Mini files config
-- ============================================================================
local show_dotfiles = true

local filter_show = function(fs_entry)
	return true
end

local filter_hide = function(fs_entry)
	return not vim.startswith(fs_entry.name, ".")
end

local toggle_dotfiles = function()
	show_dotfiles = not show_dotfiles
	local new_filter = show_dotfiles and filter_show or filter_hide
	MiniFiles.refresh({ content = { filter = new_filter } })
end

create_augroup("MiniFilesDotFilesToggle", {
	{
		event = "User",
		pattern = "MiniFilesBufferCreate",
		desc = "Toggle dot files",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak left-hand side of mapping to your liking
			vim.keymap.set("n", "I", toggle_dotfiles, { buffer = buf_id })
		end,
	},
})

local map_split = function(buf_id, lhs, direction)
	local rhs = function()
		-- Make new window and set it as target
		local cur_target = MiniFiles.get_explorer_state().target_window
		local new_target = vim.api.nvim_win_call(cur_target, function()
			vim.cmd(direction .. " split")
			return vim.api.nvim_get_current_win()
		end)

		MiniFiles.set_target_window(new_target)

		-- This intentionally doesn't act on file under cursor in favor of
		-- explicit "go in" action (`l` / `L`). To immediately open file,
		-- add appropriate `MiniFiles.go_in()` call instead of this comment.
	end

	-- Adding `desc` will result into `show_help` entries
	local desc = "Split " .. direction
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

create_augroup("MiniFilesSpitMapping", {
	{
		event = "User",
		pattern = "MiniFilesBufferCreate",
		desc = "Mapping for windows split",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak left-hand side of mapping to your liking
			map_split(buf_id, "hs", "belowright horizontal")
			map_split(buf_id, "vs", "belowright vertical")
			map_split(buf_id, "<C-t>", "tab")
		end,
	},
})

-- Set focused directory as current working directory
local set_cwd = function()
	local path = (MiniFiles.get_fs_entry() or {}).path
	if path == nil then
		return vim.notify("Cursor is not on valid entry")
	end
	vim.fn.chdir(vim.fs.dirname(path))
end

-- Yank in register full path of entry under cursor
local yank_path = function()
	local path = (MiniFiles.get_fs_entry() or {}).path
	if path == nil then
		return vim.notify("Cursor is not on valid entry")
	end
	vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function()
	vim.ui.open(MiniFiles.get_fs_entry().path)
end

create_augroup("MiniFilesCopyChangeDirectory", {
	{
		event = "User",
		pattern = "MiniFilesBufferCreate",
		desc = "Mapping for change, copy and paste cwd",
		callback = function(args)
			local b = args.data.buf_id
			vim.keymap.set("n", "cd", set_cwd, { buffer = b, desc = "Set cwd" })
			vim.keymap.set("n", "gX", ui_open, { buffer = b, desc = "OS open" })
			vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
		end,
	},
})

local set_mark = function(id, path, desc)
	MiniFiles.set_bookmark(id, path, { desc = desc })
end

create_augroup("MinifilesBookmark", {
	{
		event = "User",
		pattern = "MiniFilesExplorerOpen",
		callback = function()
			set_mark("c", vim.fn.stdpath("config"), "Config")
			set_mark("w", vim.fn.getcwd, "Working directory")
			set_mark("~", "~", "Home directory")
		end,
	},
})
