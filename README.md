# Neovim Config

Personal [LazyVim](https://www.lazyvim.org/) configuration for macOS. It includes
Git review tools, a Markdown workflow, and Go, Python, and modern frontend language
support.

## Requirements

- [Neovim](https://github.com/neovim/neovim/releases) >= 0.11.2, built with LuaJIT
- [Git](https://git-scm.com/) >= 2.19
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- A C compiler such as Xcode Command Line Tools for Treesitter parsers
- [Hunk](https://www.hunk.dev/) for `<Space>gH`
- Visual Studio Code on macOS for Markdown's `<Space>mo`
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
| `<Space>fv` | Terminal in a right split, rooted at the project |
| `<Space>gH` | Review the Git working tree in Hunk, in a LazyGit-style float |
| `<Space>ub` | Toggle Gitsigns current-line blame |
| `<Space>yP` | Copy the current file's absolute path |
| `<Space>yp` | Copy the current file's path relative to the project root |
| `<Space>mm` | Toggle the minimap |
| `<Space>cs` | Toggle the symbol outline |
| `<Space>dd` | Toggle the enhanced TypeScript error view |
| `<Space>dx` | Go to the definition for the selected TypeScript error |

### Markdown

| Key | Action |
| --- | --- |
| `<Space>mo` | Open the saved Markdown file in Visual Studio Code |

Markdownlint is disabled for Markdown and MDX buffers, so rules such as
`MD013/line-length` do not produce diagnostics. Formatting still works through the
frontend formatter selection below.

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
| TypeScript / JavaScript | `tsgo`, ESLint, Biome, OXC, Prettier | TypeScript inlay hints are enabled. ESLint supplies diagnostics. |
| JSON / JSONC / JSON5 | `jsonls`, SchemaStore | Schema validation and formatting are enabled. |
| TOML | `taplo` | Completion, validation, and formatting. |
| YAML | `yamlls`, SchemaStore | Schema validation and formatting are enabled. |
| Other enabled extras | Docker, Git, Markdown, SQL | Standard LazyVim language support. |

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
  `.git`.
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
    │   ├── autocmds.lua     # Markdown → VS Code mapping
    │   ├── keymaps.lua      # General mappings, Hunk, terminal, copy paths
    │   ├── lazy.lua         # lazy.nvim bootstrap
    │   └── options.lua      # Shared options
    └── plugins/
        ├── frontend.lua     # Biome / OXC / Prettier selection
        ├── gitsigns.lua     # Current-line blame
        ├── markdown.lua     # Disable Markdown lint diagnostics
        └── ...
```

## License

[MIT](./LICENSE)
