return {
  -- Formatter
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      -- Define which formatters to use for each filetype.
      -- Conform will run them in order.
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'autopep8' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        bash = { 'shfmt' },
      },

      -- This option enables format-on-save.
      -- It's a synchronous operation, so we need a timeout to prevent
      -- the editor from freezing if a formatter is slow or hangs.
      format_on_save = {
        -- We've increased the timeout to 1500ms to be more tolerant on
        -- slower systems or for large files. If you still get timeouts,
        -- use `:ConformInfo` to debug which formatter is failing.
        timeout_ms = 1500,
        -- If conform doesn't have a formatter configured for the filetype,
        -- it will fallback to the LSP client's formatting capability.
        lsp_fallback = true,
      },
    },
  },

  -- Linter
  {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        python = { 'flake8' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        bash = { 'shellcheck' },
      }

      -- Set up linting to run automatically on specific events.
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('LintAutocmd', { clear = true }),
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
