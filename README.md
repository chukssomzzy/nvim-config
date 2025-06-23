# Modern Neovim Config: A Full-Stack Foundation

This is a clean, fast, and powerful Neovim configuration designed for full-stack development. It is built entirely in Lua and leverages the best of modern Neovim features, including native LSP, Treesitter, and a high-performance plugin ecosystem managed by `lazy.nvim`.

The core philosophy is **clarity and performance**. The configuration is modular, well-documented, and lazy-loads plugins to ensure near-instant startup times and a smooth, responsive editing experience.

![Neovim IDE](https://user-images.githubusercontent.com/587834/204907204-58e1887e-4b63-44b4-8703-930499e1338d.png)

## Features

-   **Fast Startup**: Plugins are lazy-loaded on demand using `lazy.nvim`.
-   **Intelligent IDE Features**: Native LSP provides diagnostics, code actions, definitions, and references.
-   **Powerful Autocompletion**: `nvim-cmp` offers context-aware completions for LSP, snippets, buffers, and paths.
-   **Advanced Syntax Highlighting**: `nvim-treesitter` provides fast and accurate syntax parsing.
-   **Fuzzy Finding**: `Telescope` for quickly finding files, buffers, and text within your projects.
-   **Git Integration**: `gitsigns` in the sign column and `vim-fugitive` for powerful Git commands.
-   **Clean & Modular Structure**: Configuration is split into logical files (`options.lua`, `keymaps.lua`, etc.), making it easy to maintain and customize.

## Installation

This configuration is for **Neovim (v0.8.0+ or later)** only. It will not work with standard Vim.

#### 1. Backup Your Old Configuration
Your existing Neovim configuration will be replaced. Back it up first!
```bash
# Move your old configuration to a safe backup location
mv ~/.config/nvim ~/.config/nvim.bak
```

#### 2. Get the Configuration
Clone the repository containing this configuration.
```bash
# Replace the URL with your own repository if you host this config on Git
git clone https://github.com/your-username/your-repo-name.git ~/.config/nvim
```

#### 3. Bootstrap the Plugin Manager (`lazy.nvim`)
Neovim needs `lazy.nvim` to be present on the first run to install everything else.
```bash
# Clone lazy.nvim to its standard location
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

#### 4. Launch Neovim & Install Plugins
Start Neovim. `lazy.nvim` will automatically open, install all the plugins, and then prompt you to restart.
```bash
nvim
```
After the installation is complete, close and reopen Neovim.

#### 5. Install Language Servers
This configuration uses `mason.nvim` to manage language servers, linters, and formatters.
Run the command `:Mason` to open the Mason UI.

Inside the Mason window:
-   Move your cursor over a package you need (e.g., `pyright` for Python, `tsserver` for TypeScript).
-   Press `i` to install it.
-   Install all the language servers relevant to your work. They will be automatically configured by the LSP setup.

You are now ready to code!

---

## Keybindings

The leader key is set to `<Space>`.

### 🪟 General & Window Management

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `<leader>w`     | Save the current file.                          |
| `<leader>q`     | Smart Quit: closes buffer, or quits if last.    |
| `<leader>bd`    | Close (delete) the current buffer.              |
| `<C-h/j/k/l>`   | Navigate to the window left/down/up/right.      |
| `[b`            | Go to the previous buffer.                      |
| `]b`            | Go to the next buffer.                          |
| `<A-j>` / `<A-k>` | Move the current line or visual selection down/up. |
| `<Esc>`         | Clear search highlight.                         |

### 💻 Terminal

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `<leader>tt`    | Open a new horizontal terminal at the bottom.   |
| `<leader>tv`    | Open a new vertical terminal on the right.      |
| `<Esc>`         | (In Terminal Mode) Exit terminal mode to Normal mode. |

### 🔭 Telescope (Fuzzy Finder)

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `<leader>ff`    | Find files in your current working directory.   |
| `<leader>fg`    | Live grep for a string in your project.         |
| `<leader>fb`    | Find and switch between open buffers.           |
| `<leader>fh`    | Search Neovim's help tags.                      |

### 🧠 LSP (Language Server Protocol)

These keybindings are active only in buffers where an LSP server is attached.

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `gd`            | Go to the definition of the symbol under the cursor. |
| `gD`            | Go to the declaration of the symbol.            |
| `K`             | Display hover documentation for the symbol.     |
| `gi`            | Go to the implementation of the symbol.         |
| `gr`            | Show all references to the symbol.              |
| `<C-k>`         | Display signature help for the current function. |
| `<leader>lr`    | Rename the symbol under the cursor project-wide. |
| `<leader>la`    | Show available code actions (e.g., "organize imports"). |
| `<leader>lf`    | Format the current buffer.                      |

### 🩺 Diagnostics

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `[d`            | Go to the previous diagnostic (error, warning). |
| `]d`            | Go to the next diagnostic.                      |
| `<leader>ld`    | Show diagnostic details in a floating window.   |

### 🛠️ Tools & Utilities

| Keybinding      | Description                                     |
| :-------------- | :---------------------------------------------- |
| `gcc`           | (Normal Mode) Toggle comment for the current line. |
| `gc`            | (Visual Mode) Toggle comment for the selection.  |
| `<leader>e`     | Toggle the NERDTree file explorer.              |
| `<leader>ec`    | Edit the Neovim configuration (`init.lua`).      |

---

## Customization

This configuration is designed to be easily extended.

-   **Options**: To change global settings (like `tabstop` or `relativenumber`), edit `lua/core/options.lua`.
-   **Keybindings**: To add or change keybindings, edit `lua/core/keymaps.lua`.
-   **Plugins**: To add a new plugin:
    1.  Find the plugin on GitHub (e.g., `some-user/some-plugin.nvim`).
    2.  Add `{ 'some-user/some-plugin.nvim' }` to one of the files in `lua/plugins/`. Choose a logical file (e.g., `ui.lua` for a UI plugin, `editing.lua` for an editing plugin).
    3.  Restart Neovim. `lazy.nvim` will install it automatically.
    4.  If the plugin needs configuration, add a `config = function() ... end` block.
-   **LSPs**: To add a new language server, open Mason with `:Mason`, find the server, and press `i` to install it. No other configuration is needed.
-   **Theme**: To change the theme, edit the `folke/tokyonight.nvim` entry in `lua/plugins/ui.lua`. You can replace it with any other theme plugin.

