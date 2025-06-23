return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        path_display = { 'truncate' },
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    local map = vim.keymap.set
    map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
    map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
    map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
    map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })
  end,
}
