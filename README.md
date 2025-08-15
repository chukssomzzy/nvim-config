# Modern Neovim IDE: A Full-Stack Foundation

This is a clean, fast, and powerful Neovim configuration designed for a modern full-stack development workflow. It is built entirely in Lua and leverages the best of modern Neovim features, including native LSP, Treesitter, a DAP debugger, and a high-performance plugin ecosystem managed by `lazy.nvim`.

The core philosophy is **clarity, performance, and functionality**. The configuration is highly modular, well-documented, and lazy-loads plugins to ensure near-instant startup times and a smooth, responsive editing experience that scales from simple scripts to large codebases.

![Neovim IDE](https://user-images.githubusercontent.com/587834/204907204-58e1887e-4b63-44b4-8703-930499e1338d.png)

## Core Features

- **⚡ Fast Startup**: Plugins are lazy-loaded on demand using `lazy.nvim`.
- **🧠 Intelligent IDE Features**: Native LSP provides diagnostics, code actions, definitions, and references.
- **🤖 Powerful Autocompletion**: `nvim-cmp` offers context-aware completions for LSP, snippets, buffers, and paths.
- **🌳 Advanced Syntax Highlighting**: `nvim-treesitter` provides fast and accurate syntax parsing for numerous languages.
- **🔭 Fuzzy Finding**: `Telescope` for quickly finding files, buffers, and text within your projects.
- **🛠️ Flexible Tooling**: Combines multiple linters and formatters with `nvim-lint` and `conform.nvim`, offering a superior alternative to `ALE`.
- **🐛 Integrated Debugging**: A full debugging experience with `nvim-dap` and a clean UI via `nvim-dap-ui`.
- **💾 Session Management**: Automatically saves and restores your sessions with `persistence.nvim`.
- **📁 Clean & Modular Structure**: Configuration is split into logical files (`options.lua`, `keymaps.lua`, `plugins/`, etc.), making it easy to maintain and customize.

## Installation

This configuration is for **Neovim (v0.8.0+ or later)** only. It will not work with standard Vim.

#### 1. Backup Your Old Configuration

Your existing Neovim configuration will be replaced. Back it up first!

```bash
# Move your old configuration to a safe backup location
mv ~/.config/nvim ~/.config/nvim.bak
```

#### 2. Get the Configuration

Clone the repository containing this configuration into the correct path.

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

#### 5. Install External Tools (LSPs, Linters, Formatters)

This configuration uses `mason.nvim` to manage all external command-line tools.
Run the command `:Mason` to open the Mason UI.

Inside the Mason window, find and install the tools you need by moving the cursor over them and pressing `i`. Recommended tools to install:

- **LSPs**: `pyright`, `tsserver`, `volar` (for Vue), `gopls`, `rust_analyzer`, `lua_ls`, `emmet_ls`, `html`, `cssls`, `tailwindcss`, `jsonls`, `yamlls`, `bashls`, `dockerls`.
- **Formatters**: `isort`, `autopep8`, `prettier`, `stylua`, `shfmt`.
- **Linters**: `flake8`, `eslint_d`, `shellcheck`.

## Keybindings

The leader key is set to `<Space>`.

### 🪟 General & Window Management

| Keybinding        | Description                                        |
| :---------------- | :------------------------------------------------- |
| `<leader>w`       | Save the current file.                             |
| `<leader>sw`      | Sudo save the current file.                        |
| `<leader>q`       | Smart Quit: closes buffer, or quits if last.       |
| `<leader>bd`      | Close (delete) the current buffer.                 |
| `[b` / `]b`       | Go to the previous/next buffer.                    |
| `<C-h>`           | Move to left window.                               |
| `<C-j>`           | Move to down window.                               |
| `<C-k>`           | Move to up window.                                 |
| `<C-l>`           | Move to right window.                              |
| `<A-j>` / `<A-k>` | Move the current line or visual selection down/up. |
| `<F2>`            | Toggle line wrapping on and off.                   |
| `<Esc>`           | Clear search highlight (normal mode).              |
| `jk` (Insert)     | Escape insert mode.                                |

### 📁 File Explorer (NERDTree)

| Keybinding  | Description                        |
| :---------- | :--------------------------------- |
| `<leader>h` | Toggle the NERDTree file explorer. |

### 💻 Terminal

| Keybinding   | Description                                   |
| :----------- | :-------------------------------------------- |
| `<leader>tt` | Open a new horizontal terminal at the bottom. |
| `<leader>tv` | Open a new vertical terminal on the right.    |
| `<Esc>`      | (In Terminal Mode) Exit terminal mode.        |

### 🔭 Telescope (Fuzzy Finder)

| Keybinding   | Description                                   |
| :----------- | :-------------------------------------------- |
| `<leader>ff` | Find files in your current working directory. |
| `<leader>fg` | Live grep for a string in your project.       |
| `<leader>fb` | Find and switch between open buffers.         |
| `<leader>fh` | Search Neovim's help tags.                    |
| `<leader>fc` | Find commands.                                |
| `<leader>fs` | LSP Document Symbols.                         |
| `<leader>m`  | Find old files.                               |
| `<leader>sd` | Search Diagnostics.                           |
| `<leader>gs` | Git Status.                                   |
| `<leader>sk` | Search Keymaps.                               |

### 🧠 LSP (Code Intelligence)

| Keybinding   | Description                                             |
| :----------- | :------------------------------------------------------ |
| `gd` / `gD`  | Go to Definition / Declaration.                         |
| `K`          | Display hover documentation for the symbol.             |
| `gi` / `gr`  | Go to Implementation / Show References.                 |
| `<C-k>`      | Display signature help for the current function.        |
| `<leader>lr` | Rename the symbol under the cursor project-wide.        |
| `<leader>la` | Show available Code Actions (e.g., "organize imports"). |

### 🩺 Diagnostics (Errors & Warnings)

| Keybinding     | Description                                               |
| :------------- | :-------------------------------------------------------- |
| `<leader>ld`   | Show diagnostic details for the current line in a popup.  |
| `<leader>dp`   | Go to the **p**revious diagnostic.                        |
| `<leader>dn`   | Go to the **n**ext diagnostic.                            |
| _(Auto Hover)_ | Hovering over an error will automatically show the popup. |

### ✨ Formatting

| Keybinding      | Description                                                 |
| :-------------- | :---------------------------------------------------------- |
| `<leader>i`     | Format buffer with conform.nvim.                            |
| _(Auto Format)_ | Code is automatically formatted on save via `conform.nvim`. |
| `<leader>lf`    | Manually trigger formatting for the current buffer.         |

### 🐛 Debugging (DAP)

| Keybinding   | Description                                      |
| :----------- | :----------------------------------------------- |
| `<leader>du` | Toggle the DAP User Interface.                   |
| `<leader>db` | Toggle a breakpoint on the current line.         |
| `<leader>dB` | Set a conditional breakpoint.                    |
| `<leader>dc` | Start or **c**ontinue the debugging session.     |
| `<leader>dj` | Step **o**ver (next line, don't enter function). |
| `<leader>dk` | Step **i**nto (enter function).                  |
| `<leader>do` | Step **o**ut (exit current function).            |
| `<leader>dr` | Open the debug **R**EPL.                         |
| `<leader>dt` | **T**erminate the debugging session.             |

### 💾 Session Management

| Keybinding    | Description                                         |
| :------------ | :-------------------------------------------------- |
| _(Auto Save)_ | The current session is automatically saved on quit. |
| `<leader>qs`  | Restore session for the current directory.          |
| `<leader>ql`  | Restore the **l**ast saved session.                 |
| `<leader>qd`  | Quit without saving the session (**d**iscard).      |

### 🧑‍💻 Git Integration

| Keybinding   | Description         |
| :----------- | :------------------ |
| `<leader>gb` | Git Blame selection |
| `<leader>gd` | Git Diff this       |

### 📖 Config Documentation

| Keybinding   | Description                  |
| :----------- | :--------------------------- |
| `<leader>/`  | Show Config Help (README.md) |
| `<leader>ec` | Edit Neovim Config           |

### 🤖 CopilotChat (AI Assistant)

| Keybinding                    | Description                                    |
| :---------------------------- | :--------------------------------------------- |
| `<leader>cb`                  | Insert buffer reference via Telescope          |
| `<leader>cf`                  | Insert file reference via Telescope            |
| `<leader>coq`                 | CopilotChat - Quick chat with buffer           |
| `<leader>coo`                 | CopilotChat - Open chat                        |
| `<leader>cot`                 | CopilotChat - Toggle chat                      |
| `<leader>cop`                 | CopilotChat - Prompt actions                   |
| `<leader>coh`                 | CopilotChat - Help actions                     |
| `<leader>coe`                 | CopilotChat - Explain code (normal/visual)     |
| `<leader>cor`                 | CopilotChat - Review code (normal/visual)      |
| `<leader>cof`                 | CopilotChat - Fix code (normal/visual)         |
| `<leader>cod`                 | CopilotChat - Optimize code (normal/visual)    |
| `<leader>com`                 | CopilotChat - Generate docs (normal/visual)    |
| `<leader>cos`                 | CopilotChat - Generate tests (normal/visual)   |
| `<leader>cog`                 | CopilotChat - Generate commit message          |
| `<C-x><C-b>` (Insert in chat) | Insert buffer reference via Telescope          |
| `<C-x><C-f>` (Insert in chat) | Insert file reference via Telescope            |
| `<C-x><C-g>` (Insert in chat) | Insert files reference via Telescope           |
| `<leader>qs`                  | Restore session for the current directory.     |
| `<leader>ql`                  | Restore the **l**ast saved session.            |
| `<leader>qd`                  | Quit without saving the session (**d**iscard). |

## Customization

This configuration is designed to be easily extended.

- **Options**: To change global settings (like `tabstop`), edit `lua/core/options.lua`.
- **Keybindings**: To add or change keybindings, edit `lua/core/keymaps.lua`.
- **Plugins**: To add a new plugin, add a new spec to a file in `lua/plugins/`. Choose a logical file (e.g., `ui.lua` for a UI plugin) or create a new one.
- **LSPs, Formatters, Linters**: To add a new tool, first install it via `:Mason`. Then, if it's a formatter or linter, add it to the appropriate list in `lua/plugins/formatting.lua`. LSPs are handled automatically.
- **Theme**: To change the theme, edit the `folke/tokyonight.nvim` entry in `lua/plugins/ui.lua`.
- **Debug Adapters**: To debug a new language, install its debug adapter via `:Mason` and add a new configuration block for it in `lua/plugins/dap.lua`.
