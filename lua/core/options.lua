local g = vim.g
local opt = vim.opt

-- ============================================================================
-- Clipboard Configuration
-- ============================================================================
-- Use system clipboard by default
opt.clipboard = "unnamedplus"

-- Enhanced clipboard configuration with multiple fallbacks
-- Detect and configure clipboard provider based on available utilities
if vim.fn.executable("termux-clipboard-get") == 1 then
	-- Termux environment
	g.clipboard = {
		name = "termux",
		copy = {
			["+"] = "termux-clipboard-set",
			["*"] = "termux-clipboard-set",
		},
		paste = {
			["+"] = "termux-clipboard-get",
			["*"] = "termux-clipboard-get",
		},
		cache_enabled = true,
	}
elseif vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
	-- Wayland environment
	g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline",
		},
		cache_enabled = true,
	}
elseif vim.fn.executable("xclip") == 1 then
	-- X11 environment with xclip
	g.clipboard = {
		name = "xclip",
		copy = {
			["+"] = "xclip -quiet -i -selection clipboard",
			["*"] = "xclip -quiet -i -selection primary",
		},
		paste = {
			["+"] = "xclip -o -selection clipboard",
			["*"] = "xclip -o -selection primary",
		},
		cache_enabled = true,
	}
elseif vim.fn.executable("xsel") == 1 then
	-- X11 environment with xsel
	g.clipboard = {
		name = "xsel",
		copy = {
			["+"] = "xsel --nodetach --input --clipboard",
			["*"] = "xsel --nodetach --input --primary",
		},
		paste = {
			["+"] = "xsel --output --clipboard",
			["*"] = "xsel --output --primary",
		},
		cache_enabled = true,
	}
elseif vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1 then
	-- macOS environment
	g.clipboard = {
		name = "pbcopy",
		copy = {
			["+"] = "pbcopy",
			["*"] = "pbcopy",
		},
		paste = {
			["+"] = "pbpaste",
			["*"] = "pbpaste",
		},
		cache_enabled = true,
	}
else
	-- Fallback: disable system clipboard if no utilities available
	-- This prevents errors and ensures internal clipboard still works
	opt.clipboard = ""
	-- Create autocmd to notify user about missing clipboard utilities
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			local missing_msg = "Clipboard utilities not found. Install one of: xclip, xsel, wl-clipboard (Wayland), or pbcopy (macOS)"
			-- Use vim.notify instead of requiring snacks to avoid dependency issues
			vim.notify(missing_msg, vim.log.levels.WARN)
		end,
		once = true,
	})
end

-- ============================================================================
-- General & UI Options
-- ============================================================================
opt.mouse = "a"
opt.wrap = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.encoding = "utf-8"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes:1"
opt.laststatus = 3
opt.cmdheight = 1
opt.showmode = false

-- Set cursor shape for different modes
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Configure how special characters are displayed
opt.list = true
opt.listchars = {
	tab = "│·",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "␣",
}

-- ============================================================================
-- Tabs & Indentation
-- ============================================================================
opt.tabstop = 4 -- Default tab size
opt.shiftwidth = 4 -- Default indent size
opt.softtabstop = 4
opt.expandtab = true -- Use spaces by default
opt.autoindent = true
opt.smartindent = true

-- ============================================================================
-- Search
-- ============================================================================
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- ============================================================================
-- Performance
-- ============================================================================
opt.updatetime = 300
opt.timeoutlen = 1000

-- ============================================================================
-- Backup & Undo
-- ===========================================================================
opt.backup = true
opt.backupdir = vim.fn.stdpath("data") .. "/backup"
opt.writebackup = true
