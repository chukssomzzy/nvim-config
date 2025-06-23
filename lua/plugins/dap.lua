return {
  -- Debug Adapter Protocol client
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Installs and manages debug adapters
      {
        'williamboman/mason.nvim',
        opts = {
          ensure_installed = {
            'dap-python-debugger', -- Installs debugpy
          },
        },
      },
      { 'jay-babu/mason-nvim-dap.nvim' },

      -- A good UI for DAP
      {
        'rcarriga/nvim-dap-ui',
        -- Use our own icons for DAP UI
        dependencies = { 'nvim-tree/nvim-web-devicons', "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require('dapui')
          dapui.setup()

          -- Automatically open and close the DAP UI when a session starts/stops
          local dap = require('dap')
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },
    },
    config = function()
      local dap = require('dap')

      -- This sets up the adapters installed by mason-nvim-dap
      require('mason-nvim-dap').setup({
        handlers = {}, -- Let mason-nvim-dap handle setup
      })

      -- ===================================================================
      -- Language-Specific Configurations
      -- This is where you can add launchers for different languages.
      -- ===================================================================

      -- Python Configuration with debugpy
      -- This allows you to debug the current file without a launch.json
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}', -- This will debug the current file
          pythonPath = function()
            -- You can customize this to point to a virtual environment's Python
            return vim.fn.exepath('python')
          end,
        },
      }

      -- Set up icons for the signs column
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = '' })
    end,
  },
}
