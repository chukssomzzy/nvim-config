return {
  -- The core Copilot plugin for completions
  {
    'github/copilot.vim',
  },

  -- The new Copilot Chat plugin
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main', -- Use the main branch for the latest features
    dependencies = {
      -- These are required dependencies
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' },
    },
    -- The build command is required to compile the tokenizer
    build = 'make | make tiktoken',
    opts = {
      -- You can customize the chat window here
      window = {
        layout = 'vertical',
        width = 0.5, -- 50% of the screen width
        height = 0.9,
      },
      -- You can customize the prompt here if you want
      -- See the plugin's documentation for more options
    },
  },
}
