return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"zbirenbaum/copilot-cmp",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("copilot_cmp").setup()

		-- Custom completion source for CopilotChat context references
		local copilot_chat_source = {}
		copilot_chat_source.new = function()
			return setmetatable({}, { __index = copilot_chat_source })
		end

		copilot_chat_source.get_trigger_characters = function()
			return { "#" }
		end

		copilot_chat_source.complete = function(self, request, callback)
			local input = string.sub(request.context.cursor_before_line, request.offset)
			local items = {}

			-- Only provide completions if we're in a copilot-chat buffer and user typed #
			if vim.bo.filetype == "copilot-chat" and string.match(input, "^#") then
				items = {
					{
						label = "#buffer:",
						kind = cmp.lsp.CompletionItemKind.Reference,
						documentation = "Include content from a specific buffer by name",
						insertText = "#buffer:",
					},
					{
						label = "#file:",
						kind = cmp.lsp.CompletionItemKind.Reference,
						documentation = "Include content from a specific file by path",
						insertText = "#file:",
					},
					{
						label = "#files:",
						kind = cmp.lsp.CompletionItemKind.Reference,
						documentation = "Include content from multiple files matching a pattern (requires ripgrep)",
						insertText = "#files:",
					},
					{
						label = "#selection",
						kind = cmp.lsp.CompletionItemKind.Reference,
						documentation = "Include the current visual selection",
						insertText = "#selection",
					},
				}
			end

			callback({ items = items })
		end

		-- Register the custom completion source
		cmp.register_source("copilot_chat_context", copilot_chat_source)

		-- Default CMP setup
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "copilot" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		})

		-- Buffer-specific setup for copilot-chat filetype
		cmp.setup.filetype("copilot-chat", {
			sources = cmp.config.sources({
				{ name = "copilot_chat_context" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
	end,
}
