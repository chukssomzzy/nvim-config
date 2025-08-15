# Neovim Configuration Instructions

This project is a modular Neovim configuration using Lua and [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Structure

- `init.lua`: Loads core settings and plugins.
- `lua/core/`: Core configuration:
  - `options.lua`: Neovim options.
  - `keymaps.lua`: Key mappings.
  - `autocmds.lua`: Autocommands.
- `lua/plugins/`: Plugin configurations, one file per plugin/group.
- `lazy-lock.json`: Plugin version lockfile.

## Setup

1. **Install Neovim (v0.8+)**.
2. **Clone this repo**:
   ```sh
   git clone <repo-url> ~/.config/nvim
   ```
3. **Start Neovim**. Plugins auto-install via lazy.nvim.
4. **Update plugins**:
   ```
   :Lazy sync
   ```

## Plugin Usage & Key Mappings

### Telescope (`lua/plugins/telescope.lua`)

- **Find files**: `<leader>ff`
- **Live grep**: `<leader>fg`
- **Buffers**: `<leader>fb`
- **Help tags**: `<leader>fh`
- **Command**: `:Telescope <builtin>`

### LSP (`lua/plugins/lsp.lua`)

- **Go to definition**: `gd`
- **Hover docs**: `K`
- **Rename symbol**: `<leader>rn`
- **Code actions**: `<leader>ca`
- **Format**: `<leader>fm`
- **Command**: `:LspInfo`

### Treesitter (`lua/plugins/treesitter.lua`)

- **Syntax highlighting**: Enabled by default.
- **Incremental selection**: `<C-space>`
- **Text objects**: See plugin docs.

### Completion (`lua/plugins/cmp.lua`)

- **Trigger completion**: `<C-Space>`
- **Confirm selection**: `<CR>`
- **Navigate**: `<Tab>`, `<S-Tab>`

### Debug Adapter Protocol (`lua/plugins/dap.lua`)

- **Start debug**: `<F5>`
- **Step over**: `<F10>`
- **Step into**: `<F11>`
- **Toggle breakpoint**: `<leader>db`
- **Command**: `:DapToggleBreakpoint`

### Formatting (`lua/plugins/formatting.lua`)

- **Format buffer**: `<leader>fm`
- **Autoformat on save**: Enabled via autocommand.

### Copilot (`lua/plugins/copilot.lua`)

- **Accept suggestion**: `<C-/>`
- **Next/Prev suggestion**: `<M-]>`, `<M-[>`

### UI Enhancements (`lua/plugins/ui.lua`)

- **File explorer**: `<leader>e`
- **Statusline, tabline**: Custom via plugin.

### Other Plugins

- See respective files in `lua/plugins/` for more mappings and commands.

## Style Guidelines

### File Structure

Organize files as follows:

```
nvim/
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── autocmds.lua
│   └── plugins/
│       ├── telescope.lua
│       ├── lsp.lua
│       ├── formatting.lua
│       ├── dap.lua
│       ├── extended.lua
│       ├── cmp.lua
│       ├── mcp.lua
│       ├── treesitter.lua
│       ├── editing.lua
│       ├── chat.lua
│       ├── ui.lua
│       ├── tools.lua
│       └── copilot.lua
├── lazy-lock.json
└── README.md
```

### Coding Conventions

- **Lua files only** for configuration.
- **Each plugin/group in its own file** under `lua/plugins/`.
- **Core settings** (options, keymaps, autocommands) in `lua/core/`.
- **Use local functions and variables** unless global scope is required.
- **Comment all non-trivial logic** and document plugin-specific settings.
- **Key mappings**: Use `<leader>` for custom mappings, document in comments.
- **Consistent indentation** (2 spaces recommended).
- **Prefer table-based configuration** for plugins.
- **Avoid magic numbers/strings**; use named constants.
- **Document new features and changes** in this file for AI context.

### Adding Features

- Place new plugin configs in `lua/plugins/`.
- Update this file with new key mappings, commands, and usage.
- Follow existing patterns for plugin setup and mappings.
- Ensure new code is modular and maintainable.

## Troubleshooting

- Run `:Lazy sync` if plugins fail.
- Check `lazy-lock.json` for version issues.
- Use `:messages` for error logs.
