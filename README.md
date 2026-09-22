# Neovim Config

Personal [LazyVim](https://www.lazyvim.org/) configuration for macOS. It includes
Git review tools, a Markdown workflow, project task running via Overseer, one-key
launch of the project in external editors, and Go, Python, and modern frontend
language support.

## Requirements

- [Neovim](https://github.com/neovim/neovim/releases) >= 0.11.2, built with LuaJIT
- [Git](https://git-scm.com/) >= 2.19
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- A C compiler such as Xcode Command Line Tools for Treesitter parsers
- [Hunk](https://www.hunk.dev/) for `<Space>gH`
- macOS for the `<Space>mo` external Markdown opener; the default app is Visual
  Studio Code, configurable via `markdown_external_app` in `lua/config/keymaps.lua`
- Visual Studio Code, WebStorm, or Zed for the `<Space>pc` / `<Space>pw` / `<Space>pz`
  project openers; each is checked at launch time and only the one you use needs to
  be installed
- [lazygit](https://github.com/jesseduffield/lazygit) is optional; LazyVim maps it to
  `<Space>gg` when installed

## Install

```sh
git clone https://github.com/coffeedeveloper/nvim-config.git ~/.config/nvim
nvim
```

On first start, `lazy.nvim` bootstraps itself and installs plugins. Mason installs
the configured language servers and external formatters as they are needed.

Useful commands:

- `:Lazy` — manage plugins
- `:LazyExtras` — inspect LazyVim extras
- `:Mason` — inspect language tools
- `:LspInfo` — inspect clients attached to the current buffer
- `:LazyFormatInfo` — see the formatter selected for the current buffer
- `:NodeModules` — open the current project's `node_modules` with the Explorer
- `:NodeModules files` — search filenames inside the current project's `node_modules`
- `:NodeModules grep` — search contents inside the current project's `node_modules`
- `:checkhealth` — check the environment

## Keymaps

`<leader>` is `<Space>`.

### Insert mode

| Key | Action |
| --- | --- |
| `<C-a>` / `<C-e>` | Start / end of line |
| `<C-b>` / `<C-f>` | Move left / right |
| `<C-n>` / `<C-p>` | Move down / up |
| `<C-d>` | Delete character under cursor |
| `<C-k>` | Delete to end of line |

### Normal mode

| Key | Action |
| --- | --- |
| `<Space>e` | Toggle the Snacks Explorer at the project root |
| `<Space>fv` | Terminal in a right split, rooted at the project |
| `<Space>gH` | Review the Git working tree in Hunk, in a LazyGit-style float |
| `<Space>ub` | Toggle Gitsigns current-line blame |
| `<Space>yP` | Copy the current file's absolute path |
| `<Space>yp` | Copy the current file's path relative to the project root |
| `<Space>fN` | Search filenames inside the current project's `node_modules` |
| `<Space>sN` | Search contents inside the current project's `node_modules` |
| `<Space>mm` | Toggle the minimap |
| `<Space>cs` | Toggle the symbol outline |
| `<Space>dd` | Toggle the enhanced TypeScript error view |
| `<Space>dx` | Go to the definition for the selected TypeScript error |
| `<Space>pc` | Open the project root in Visual Studio Code |
| `<Space>pw` | Open the project root in WebStorm |
| `<Space>pz` | Open the project root in Zed |

### Tasks (Overseer)

| Key | Action |
| --- | --- |
| `<Space>oo` | Run task (pick from auto-discovered tasks) |
| `<Space>ow` | Toggle the task list |
| `<Space>ot` | Task action for the selected task |

Overseer discovers tasks from `package.json` scripts, `Makefile`, Go commands,
Justfiles, and more, so there is nothing to configure for common projects. Failing
task output is parsed into the quickfix list.

### Terminal mode

Snacks terminal buffers pass common macOS/Readline controls through to the shell
instead of Neovim:

| Key | Typical shell behavior |
| --- | --- |
| `<C-a>` / `<C-e>` | Beginning / end of line |
| `<C-b>` / `<C-f>` | Move backward / forward |
| `<C-n>` / `<C-p>` | Next / previous history entry |
| `<C-k>` / `<C-u>` | Kill to end / beginning of line |
| `<C-w>` / `<C-d>` | Delete previous word / delete character or EOF |
| `<C-h>` / `<C-j>` / `<C-l>` | Backspace / newline / clear screen |

LazyVim's terminal window-navigation mappings for `<C-h>`, `<C-j>`, `<C-k>`, and
`<C-l>` are disabled so the shell receives the native controls.

### Explorer

Inside the Snacks Explorer:

- `N` toggles `node_modules` visibility for the current Explorer instance.
- `a` creates a file or directory.
- `I` toggles other Git-ignored files.
- `H` toggles hidden files.
- `<leader>/` searches the current Explorer directory.
- `<C-t>` opens a terminal in the current directory.

The Explorer initially excludes `node_modules` and `.git`. There is intentionally
no `<Space>eN` mapping; use `N` while the Explorer is open.

### Markdown

| Key | Action |
| --- | --- |
| `<Space>mo` | Open the current Markdown file in an external macOS app |

The default app is Visual Studio Code. Change `markdown_external_app` near the top
of `lua/config/keymaps.lua` to use another macOS app, such as Typora or Obsidian.
Paths are passed as separate process arguments; Obsidian paths are URI-encoded and
must be inside a registered vault.

Markdownlint sources are disabled for Markdown and MDX buffers (both `nvim-lint`
and `none-ls`), so rules such as `MD013/line-length` do not produce diagnostics.
Blink completion is also disabled for these filetypes. Formatting still works
through the frontend formatter selection below.

Markdown spell checking uses English plus CJK (`spelllang = en,cjk`) so Chinese
text is not marked, with camelCase words accepted.

## Sessions

`persistence.nvim` keeps a separate session per project and Git branch, and
restores it when Neovim starts without an explicit file (including `nvim .`).
`<Space>ql` still restores the last global session.

## Git workflow

- **Gitsigns** shows changed-line signs and, after a 300 ms pause, the author, date,
  and summary for the current line. The annotation is shown at the end of that line.
- **Hunk** opens `hunk diff` from the current Git root with `<Space>gH`.
- `mini-diff` is intentionally disabled; Gitsigns is the sole Git change indicator.

## Languages and tools

LazyVim extras are declared in [lazyvim.json](./lazyvim.json).

| Area | Language server / tools | Notes |
| --- | --- | --- |
| Go | `gopls`, `goimports`, `gofumpt`, `golangci-lint`, Delve | Go imports and formatting are applied through Conform. |
| Python | `pyright`, `ruff`, `venv-selector`, `debugpy` | Pyright supplies type analysis; Ruff supplies linting. |
| TypeScript / JavaScript | `tsc`, ESLint, Biome, OXC, Prettier | TypeScript inlay hints are enabled. `tsc` and ESLint supply diagnostics. |
| JSON / JSONC / JSON5 | `jsonls`, SchemaStore | Schema validation and formatting are enabled. |
| TOML | `taplo` | Completion, validation, and formatting. |
| YAML | `yamlls`, SchemaStore | Schema validation and formatting are enabled. |
| Other enabled extras | Docker, Git, Markdown, SQL | Standard LazyVim language support. |
| Editor extras | outline, overseer | Symbol outline on `<Space>cs`; task runner on `<Space>o*`. |

For frontend filetypes, the formatter is selected from the project configuration:

1. `biome.json`, `biome.jsonc`, `.biome.json`, or `.biome.jsonc` → `biome check`
2. `.oxfmtrc.json`, `.oxfmtrc.jsonc`, `oxfmt.config.ts`, or a Vite config → `oxfmt`
3. Otherwise → Prettier

Only one formatter runs per buffer. ESLint auto-formatting is disabled so it does not
compete with Biome, OXC, or Prettier.

## UI and editing

- Catppuccin follows `:set background=light` or `dark` using Latte and Macchiato.
- The minimap opens on the right and includes search, diagnostic, and Git diff marks.
- Snacks file pickers show hidden and ignored files while excluding `node_modules` and
  `.git` initially; `N` in the Explorer toggles `node_modules` for that instance.
- Bash Tree-sitter parsing is registered for `sh` buffers.
- Blink completion accepts items with `<Tab>` or `<Enter>` and preserves the insert
  mode movement shortcuts when the completion menu is closed.
- Bufferline is always visible.
- Markdown spell checking handles camelCase terms and uses a project dictionary for
  tooling names and common acronyms such as Config, LazyVim, Gitsigns, HTTP, and API.

## Layout

```text
.
├── init.lua
├── lazyvim.json             # Enabled LazyVim extras
├── lazy-lock.json           # Pinned plugin revisions
├── stylua.toml
└── lua/
    ├── config/
    │   ├── autocmds.lua     # Markdown spell checking (en + cjk, camel)
    │   ├── keymaps.lua      # General mappings, Hunk, node_modules, external editors, Markdown opener
    │   ├── lazy.lua         # lazy.nvim bootstrap
    │   └── options.lua      # Shared options and spellfile
    └── plugins/
        ├── bash.lua         # Bash Tree-sitter grammar for sh buffers
        ├── frontend.lua     # Biome / OXC / Prettier selection
        ├── gitsigns.lua     # Current-line blame
        ├── markdown.lua     # Disable Markdown lint diagnostics
        ├── noice.lua        # Suppress transient LSP progress popups
        ├── persistence.lua  # Per-project, per-branch session restore
        ├── snacks.lua       # Picker, Explorer, and terminal behavior
        └── ...
```

## License

[MIT](./LICENSE)
