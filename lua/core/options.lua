local opt = vim.opt
local g = vim.g

-- ============================================================================
-- Clipboard Configuration
-- ============================================================================
-- Use system clipboard by default
opt.clipboard = "unnamedplus"

-- Smartly configure clipboard for Termux vs. Desktop Linux
if vim.fn.has("unix") == 1 then
	if vim.fn.executable("termux-clipboard-get") == 1 then
		g.clipboard = {
			name = "termux-clipboard",
			copy = { ["+"] = "termux-clipboard-set", ["*"] = "termux-clipboard-set" },
			paste = { ["+"] = "termux-clipboard-get", ["*"] = "termux-clipboard-get" },
			cache_enabled = 1,
		}
	elseif vim.fn.executable("xclip") == 1 then
		g.clipboard = {
			name = "xclip-clipboard",
			copy = { ["+"] = "xclip -selection clipboard", ["*"] = "xclip -selection clipboard" },
			paste = { ["+"] = "xclip -selection clipboard -o", ["*"] = "xclip -selection clipboard -o" },
			cache_enabled = 1,
		}
	end
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
opt.updatetime = 250
opt.timeoutlen = 300

-- ============================================================================
-- Backup & Undo
-- ===========================================================================
opt.backup = true
opt.backupdir = vim.fn.stdpath("data") .. "/backup"
opt.writebackup = true
