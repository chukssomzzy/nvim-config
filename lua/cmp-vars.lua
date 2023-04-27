
local cmp = require'cmp'
--setup cmp-path 
cmp.setup({
        --path to cmp-core
        sources = {
            { name = 'path' ,
                option={
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


--cmp comand line 
cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
    })  
cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

--disabling cmp for comments 
cmp.setup({
        enabled = function()
            -- disable completion in comments
            local context = require 'cmp.config.context'
            -- keep command mode completion enabled when cursor is in a comment
            if vim.api.nvim_get_mode().mode == 'c' then
                return true
            else
                return not context.in_treesitter_capture("comment") 
                and not context.in_syntax_group("Comment")
            end
        end
    })

--cmp emoji 
cmp.setup({
        sources = {
            { name = 'emoji' ,
                option = {
                    insert = true,
                }
            }
        }
    })

--cmp spell 
  cmp.setup({
    sources = {
      { name = 'spell' }
    }
  })

  --cmp snippets 
  cmp.setup({
    sources = {
      { name = 'snippets' }
    }
  })

  --cmp treesitter 
  cmp.setup({
    sources = {
      { name = 'treesitter' }
    }
  })

  --cmp vim_dadbod_completion 
  cmp.setup({
    sources = {
      { name = 'vim_dadbod_completion' }
    }
  })

  --cmp vim_lua 
  cmp.setup({
    sources = {
      { name = 'vim_lua' }
    }
  })   

 -- cmp nvim_lsp 
  cmp.setup({
    sources = {
      { name = 'nvim_lsp' }
    }
}) 

