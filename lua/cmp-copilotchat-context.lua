-- Custom CMP source for CopilotChat context references
local source = {}

function source:is_available()
	-- Only available in copilot-chat file type
	return vim.bo.filetype == "copilot-chat"
end

function source:get_trigger_characters()
	return { "#" }
end

function source:complete(params, callback)
	local context = params.context
	local cursor_before_line = context.cursor_before_line

	-- Check if we're after a # character
	if not cursor_before_line:match("#[^%s]*$") then
		callback({ items = {}, isIncomplete = false })
		return
	end

	local items = {}

	-- Get the current input after #
	local input = cursor_before_line:match("#([^%s]*)$") or ""

	-- Context reference completions
	local completions = {
		{
			label = "#buffer:",
			kind = require("cmp").lsp.CompletionItemKind.Reference,
			detail = "Reference a specific buffer",
			documentation = "Reference a specific buffer by name. Use telescope to select.",
		},
		{
			label = "#file:",
			kind = require("cmp").lsp.CompletionItemKind.File,
			detail = "Reference a specific file",
			documentation = "Reference a specific file. Use telescope to select.",
		},
		{
			label = "#files:",
			kind = require("cmp").lsp.CompletionItemKind.Folder,
			detail = "Reference files matching a pattern",
			documentation = "Reference multiple files using a glob pattern (requires ripgrep).",
		},
		{
			label = "#selection",
			kind = require("cmp").lsp.CompletionItemKind.Text,
			detail = "Reference current selection",
			documentation = "Reference the currently selected text.",
		},
	}

	-- Filter completions based on input
	for _, completion in ipairs(completions) do
		local label_without_hash = completion.label:sub(2) -- Remove the #
		if label_without_hash:lower():find(input:lower(), 1, true) == 1 or input == "" then
			-- Calculate the range to replace (just the part after #)
			local start_col = context.cursor.col - #input
			completion.textEdit = {
				range = {
					start = {
						line = context.cursor.line,
						character = start_col,
					},
					["end"] = {
						line = context.cursor.line,
						character = context.cursor.col,
					},
				},
				newText = label_without_hash,
			}
			table.insert(items, completion)
		end
	end

	callback({ items = items, isIncomplete = false })
end

return source