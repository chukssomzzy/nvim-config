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
create_augroup('FileTypeSettings', {
  -- 2 spaces for web dev, yaml, etc.
  {
    event = 'FileType',
    pattern = { 'html', 'css', 'javascript', 'typescript', 'tsx', 'json', 'yaml', 'sql' },
    desc = 'Set indent to 2 spaces',
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
    end,
  },
  -- 4 spaces for C, Python, etc.
  {
    event = 'FileType',
    pattern = { 'c', 'python', 'sh', 'ruby', 'htmldjango', 'go' },
    desc = 'Set indent to 4 spaces',
    callback = function()
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
    end,
  },
  -- 8 spaces for assembly
  {
    event = 'FileType',
    pattern = 'nasm',
    desc = 'Set indent to 8 spaces for asm',
    callback = function()
      vim.bo.shiftwidth = 8
      vim.bo.tabstop = 8
      vim.bo.softtabstop = 8
    end,
  },
  -- Use real tabs for specific filetypes if desired
  {
    event = 'FileType',
    pattern = { 'c', 'go', 'make' },
    desc = 'Use real tabs',
    callback = function()
      vim.bo.expandtab = false
    end,
  },
})

-- ============================================================================
-- Quality of Life Autocommands
-- ============================================================================
create_augroup('GeneralAutocmds', {
  -- Highlight the text you just pasted
  {
    event = 'TextYankPost',
    pattern = '*',
    desc = 'Highlight yanked text',
    callback = function()
      vim.highlight.on_yank({ timeout = 200 })
    end,
  },
  -- Remove trailing whitespace on save
  {
    event = 'BufWritePre',
    pattern = '*',
    desc = 'Remove trailing whitespace on save',
    callback = function()
      local save_cursor = vim.fn.getpos('.')
      vim.cmd [[%s/\s\+$//e]]
      vim.fn.setpos('.', save_cursor)
    end,
  },
})

-- ============================================================================
-- Diagnostic Hover
-- ============================================================================
-- This autocommand will automatically open the diagnostic float window
-- when the cursor rests on a line with an error or warning.
create_augroup('DiagnosticHover', {
  {
    event = 'CursorHold',
    pattern = '*',
    desc = 'Show diagnostic popup on hover',
    callback = function()
      vim.diagnostic.open_float(nil, {
        focus = false, -- Don't steal focus from the editor
        scope = 'cursor',
      })
    end,
  },
})
