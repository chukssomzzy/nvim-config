local DEFAULT_SETTINGS = {
	-- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "sumneko_lua" }
	-- This setting has no relation with the `automatic_installation` setting.
	ensure_installed = {clangd, cssls, emmet_ls, eslint, diagnosticls, grammarly, html, sumneko_lua, marksman,sqlls, tailwindcss, vimls, rust_analyzer, pyright},

	-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
	-- This setting has no relation with the `ensure_installed` setting.
	-- Can either be:
	--   - false: Servers are not automatically installed.
	--   - true: All servers set up via lspconfig are automatically installed.
	--   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
	--       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
	automatic_installation = true,
}
require("mason-lspconfig").setup(DEFAULT_SETTINGS)


require("mason-lspconfig").setup_handlers {
	-- Default handler (optional):
	function (server_name)
		require("lspconfig")[server_name].setup {}
	end,


	-- Dedicated handler for "clangd":

}

require("lspconfig").clangd.setup {
	cmd = { "clangd" }, -- Or your custom clangd command
}  
