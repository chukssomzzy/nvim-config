return {
  -- Smart commenting
  { 'numToStr/Comment.nvim', opts = {} },

  -- Auto-saving
  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup({ enabled = true })
    end,
  },

  -- Surrounding text objects
  { 'tpope/vim-surround' },

  -- Extra text objects and motions
  { 'tpope/vim-unimpaired' },
}
