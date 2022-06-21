
    local cmp = require'cmp'
  --setup cmp-path 
  cmp.setup({
    --path to cmp-core
  sources = {
    { name = 'path' ,
        optiom={
            trailing_slash = true
        },
    },
  },
})

--cmp buffer config 
local cmp_buffer = require('cmp_buffer')

 cmp.setup({
  sources = {
    {
      name = 'buffer',
      -- Correct:
      option = {
        keyword_pattern = [[\k\+]],
      },
    },
  },
  sorting = {
    comparators = {
      function(...) return cmp_buffer:compare_locality(...) end,
      -- The rest of your comparators...
    }
    }
})

--cmp lsp compe 

cmp.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'tsserver','tailwindcss','html','jsonls','emmet_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
--cmp comand line 
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })  
