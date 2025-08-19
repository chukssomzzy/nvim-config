# Modern Neovim IDE: A Full-Stack Foundation

This is a clean, fast, and powerful Neovim configuration designed for a modern full-stack development workflow. It is built entirely in Lua and leverages the best of modern Neovim features, including native LSP, Treesitter, a DAP debugger, and a high-performance plugin ecosystem managed by `lazy.nvim`.

The core philosophy is **clarity, performance, and functionality**. The configuration is highly modular, well-documented, and lazy-loads plugins to ensure near-instant startup times and a smooth, responsive editing experience that scales from simple scripts to large codebases.

![Neovim IDE](https://user-images.githubusercontent.com/587834/204907204-58e1887e-4b63-44b4-8703-930499e1338d.png)

## Core Features

- **⚡ Fast Startup**: Plugins are lazy-loaded on demand using `lazy.nvim`.
- **🧠 Intelligent IDE Features**: Native LSP provides diagnostics, code actions, definitions, and references.
- **🤖 Powerful Autocompletion**: `nvim-cmp` offers context-aware completions for LSP, snippets, buffers, and paths.
- **🚀 AI-Powered Coding**: Integrated CopilotChat and Avante.nvim for intelligent code suggestions and fast apply with 95% accuracy.
  - **CopilotChat**: Interactive AI conversations for code explanations, reviews, and suggestions  
  - **Avante.nvim**: Fast apply functionality with context-aware automatic application
  - **GitHub Copilot Integration**: Uses exclusively GitHub Copilot as the AI provider (no external API dependencies)
  - **Smart Apply Workflow**: Manual confirmation prevents unwanted changes with preview options
- **🌳 Advanced Syntax Highlighting**: `nvim-treesitter` provides fast and accurate syntax parsing for numerous languages.
- **🔭 Fuzzy Finding**: `Telescope` for quickly finding files, buffers, and text within your projects.
- **🛠️ Flexible Tooling**: Combines multiple linters and formatters with `nvim-lint` and `conform.nvim`, offering a superior alternative to `ALE`.
- **🐛 Integrated Debugging**: A full debugging experience with `nvim-dap` and a clean UI via `nvim-dap-ui`.
- **💾 Session Management**: Automatically saves and restores your sessions with `persistence.nvim`.
- **📁 Clean & Modular Structure**: Configuration is split into logical files (`options.lua`, `keymaps.lua`, `plugins/`, etc.), making it easy to maintain and customize.
- **🎨 Modern UI**: Uses `snacks.nvim` for modern notifications, input dialogs, and UI enhancements, replacing archived plugins like `nvim-notify` and `dressing.nvim`.

## AI Integration Overview

This configuration features a comprehensive AI-powered development environment with two complementary tools:

### CopilotChat - Interactive AI Assistant
- **Purpose**: Interactive conversations, code explanations, and guided development
- **Best for**: Learning, debugging, code reviews, generating documentation and tests
- **Workflow**: Chat-based interaction with context-aware responses

### Avante.nvim - Fast Apply AI Coding
- **Purpose**: Direct code modification with fast apply functionality  
- **Best for**: Quick code changes, refactoring, and automatic implementation of suggestions
- **Workflow**: Context-aware suggestions with manual confirmation for accuracy
- **Features**:
  - **95% accuracy** with GitHub Copilot provider (temperature = 0 for deterministic results)
  - **Smart Apply**: Analyzes cursor position and code context for intelligent application
  - **Fast Apply**: Confirmation-based application with preview option
  - **Manual Control**: No auto-apply to prevent unwanted changes

### Combined AI Workflow
Use `<leader>ca` to open both tools simultaneously for comprehensive AI assistance:
- **CopilotChat** for interactive guidance and explanations
- **Avante** for direct code application and fast implementation

Both tools are configured to use **exclusively GitHub Copilot** as the AI provider, ensuring consistent behavior and eliminating external API dependencies.

## Prerequisites

This configuration requires:

- **Neovim (v0.8.0+ or later)** - This will not work with standard Vim
- **Git** - For plugin management and version control
- **Node.js (14+)** - Required for various LSP servers and tools
- **GitHub Copilot subscription** - For AI-powered features (Avante.nvim and CopilotChat)
- **Build tools** - `make`, `gcc`/`clang` for compiling Avante.nvim and other native dependencies
- **curl** - For downloading external tools and updates

### External Dependencies (Auto-installed via Mason)

The configuration uses `mason.nvim` to automatically install these tools:
- **Language Servers**: `pyright`, `tsserver`, `lua_ls`, `gopls`, `rust_analyzer`, etc.
- **Formatters**: `prettier`, `stylua`, `autopep8`, `isort`, etc.  
- **Linters**: `eslint_d`, `flake8`, `shellcheck`, etc.

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

**Note**: On first startup, Avante.nvim will compile its native components using `make`. This may take a few minutes but only happens once.

After the installation is complete, close and reopen Neovim.

#### 5. Configure GitHub Copilot (Required for AI Features)

This configuration requires GitHub Copilot for AI functionality. If you haven't set it up:

1. **Install GitHub Copilot**: Ensure you have a valid GitHub Copilot subscription
2. **Authenticate**: Run `:Copilot auth` in Neovim and follow the authentication process
3. **Verify**: Run `:Copilot status` to ensure it's working properly

Without GitHub Copilot, the AI features (CopilotChat and Avante.nvim) will not function.

#### 6. Install External Tools (LSPs, Linters, Formatters)

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

### 🚀 Avante.nvim (AI Fast Apply)

| Keybinding   | Description                                           |
| :----------- | :---------------------------------------------------- |
| `<leader>aa` | Avante - Ask AI (normal/visual)                      |
| `<leader>ar` | Avante - Refresh AI suggestions                      |
| `<leader>ae` | Avante - Edit with AI (normal/visual)                |
| `<leader>af` | Avante - Fast apply with confirmation (95% accuracy) |
| `<leader>as` | Avante - Smart apply based on context                |
| `<leader>aA` | Avante - Apply all suggestions                        |
| `<leader>at` | Avante - Toggle sidebar                               |
| `<leader>ca` | Combined AI - Open both CopilotChat and Avante       |

#### Avante.nvim Dependencies

Avante.nvim requires several dependencies that are automatically installed:

| Dependency                              | Purpose                                          |
| :-------------------------------------- | :----------------------------------------------- |
| `nvim-treesitter/nvim-treesitter`      | Syntax parsing for code understanding           |
| `nvim-lua/plenary.nvim`                | Lua utility functions                           |
| `MunifTanjim/nui.nvim`                 | UI components for Avante interface              |
| `nvim-tree/nvim-web-devicons`          | File type icons in Avante sidebar               |
| `zbirenbaum/copilot.lua`               | GitHub Copilot integration                      |
| `HakonHarnes/img-clip.nvim`            | Image pasting support in chat                   |
| `MeanderingProgrammer/render-markdown` | Markdown rendering for AI responses              |
| `folke/snacks.nvim`                    | Modern notifications and UI enhancements        |

#### Custom Commands
- `:AventeFastApply` - Fast apply with confirmation dialog
- `:AventeSmartApply` - Context-aware smart application

### 💾 Session Management
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

## Modern UI Architecture

This configuration uses **snacks.nvim** as the foundation for a modern, maintainable UI system:

### Replaced Archived Plugins
- **nvim-notify** → **snacks.nvim notifications** - Modern notification system without vim.notify overrides
- **dressing.nvim** → **snacks.nvim input/select** - Enhanced input dialogs and selection UI

### Benefits
- **Reliable Startup**: No circular dependencies or startup hangs
- **Modern UI**: Beautiful notifications and input dialogs
- **Active Maintenance**: Uses actively maintained plugins vs. archived alternatives
- **Safe Integration**: No vim.notify overrides that could interfere with plugin initialization

## Troubleshooting

### Common Issues

#### AI Features Not Working
- **Check Copilot Status**: Run `:Copilot status` to verify authentication
- **Re-authenticate**: Run `:Copilot auth` if needed
- **Network Issues**: Ensure you have internet access for Copilot API calls

#### Plugin Installation Issues  
- **Update Plugins**: Run `:Lazy sync` to update all plugins
- **Clear Cache**: Run `:Lazy clear` to clear plugin cache
- **Restart Neovim**: Close and reopen Neovim after plugin changes

#### Avante.nvim Build Issues
- **Install Build Tools**: Ensure `make` and `gcc`/`clang` are installed
- **Manual Rebuild**: Run `:Lazy build avante.nvim` to rebuild manually
- **Check Dependencies**: Verify all dependencies are installed via `:Lazy`

#### UI Issues
- **Notification Problems**: If notifications don't appear, check `:Lazy` for snacks.nvim installation
- **Input Dialog Issues**: Verify snacks.nvim is properly configured in `lua/plugins/ui.lua`

#### Performance Issues
- **Startup Time**: Run `:Lazy profile` to identify slow-loading plugins
- **Large Files**: Some features may be slower on very large files (>1MB)

For more detailed troubleshooting, check `:messages` for error logs and `:checkhealth` for system diagnostics.
