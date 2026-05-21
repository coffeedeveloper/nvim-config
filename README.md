# 💤 Neovim Config

My personal Neovim configuration, built on top of [LazyVim](https://github.com/LazyVim/LazyVim).

It adds a Catppuccin theme that follows light/dark mode, a minimap, a symbol outline,
inline git blame, prettier TypeScript errors, macOS / Emacs-style shortcuts in insert
mode, and a handful of LSP and completion tweaks.

## Requirements

- [Neovim](https://github.com/neovim/neovim/releases) >= 0.9.0 (built with LuaJIT)
- [Git](https://git-scm.com/) >= 2.19.0 (for partial clones)
- A [Nerd Font](https://www.nerdfonts.com/) (recommended, for icons)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — used by pickers / grep
- [fd](https://github.com/sharkdp/fd) — used by file pickers
- [lazygit](https://github.com/jesseduffield/lazygit) (optional) — for the git UI
- A C compiler (`gcc`, `clang`, or Xcode CLT on macOS) — for treesitter parsers

## How to use

> ⚠️ This replaces your existing Neovim config. Back up `~/.config/nvim`,
> `~/.local/share/nvim`, `~/.local/state/nvim`, and `~/.cache/nvim` first if you have one.

1. Back up any existing config:

   ```sh
   mv ~/.config/nvim         ~/.config/nvim.bak
   mv ~/.local/share/nvim    ~/.local/share/nvim.bak
   mv ~/.local/state/nvim    ~/.local/state/nvim.bak
   mv ~/.cache/nvim          ~/.cache/nvim.bak
   ```

2. Clone this repo into `~/.config/nvim`:

   ```sh
   git clone https://github.com/coffeedeveloper/nvim-config.git ~/.config/nvim
   ```

3. Launch Neovim. `lazy.nvim` will bootstrap itself and install all plugins on first run:

   ```sh
   nvim
   ```

4. Once installation finishes, restart Neovim. You're done.

### Useful commands

- `:Lazy` — open the plugin manager UI (install / update / clean)
- `:LazyExtras` — toggle LazyVim language / feature extras
- `:Mason` — manage LSP servers, formatters, linters, and DAP adapters
- `:checkhealth` — verify your environment is set up correctly

## What's customized

### Custom insert-mode keymaps (`lua/config/keymaps.lua`)

macOS / Emacs-style editing in insert mode:

| Key       | Action                          |
| --------- | ------------------------------- |
| `<C-a>`   | Jump to beginning of line       |
| `<C-e>`   | Jump to end of line             |
| `<C-f>`   | Move forward one character      |
| `<C-b>`   | Move backward one character     |
| `<C-n>`   | Move to next line               |
| `<C-p>`   | Move to previous line           |
| `<C-d>`   | Delete character forward        |
| `<C-k>`   | Kill to end of line             |

Normal mode:

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<leader>fv` | Open a terminal in a right split    |
| `<leader>mm` | Toggle the minimap                  |
| `<leader>cs` | Toggle the symbol outline           |
| `<leader>ub` | Toggle inline git blame             |
| `<leader>dd` | Toggle better TS error popup        |
| `<leader>dx` | Jump to TS error definition         |

### Plugins (`lua/plugins/`)

- **catppuccin** — colorscheme that auto-switches `macchiato` / `latte` with `:set background`
- **mini.map** — code minimap on the right with search/diagnostic/diff integrations
- **blink.cmp** — completion menu with `<Tab>` / `<Enter>` to accept and macOS keys
  falling through to cursor motion when the menu is hidden
- **nvim-lspconfig** — disables the default `<C-k>` signature help (so `<C-k>` can kill
  to EOL) and enables full TypeScript inlay hints via `tsgo`
- **gitsigns** — inline blame at end of the current line (author, date, summary)
- **better-ts-errors** — readable TypeScript error popup with object/type formatting
  (requires global `prettier`: `npm i -g prettier`)
- **snacks** — picker shows hidden / gitignored files (but excludes `node_modules` and `.git`)
- **bufferline** — always visible

### LazyVim extras (`lazyvim.json`)

- Editor: `mini-diff`, `outline`
- Languages: `docker`, `git`, `go`, `json`, `markdown`, `python`, `sql`, `toml`,
  `typescript` (+ `biome`, `oxc`, `tsgo`), `yaml`

## Layout

```
.
├── init.lua                 # entry point — loads config.lazy
├── lazyvim.json             # LazyVim extras + version
├── lazy-lock.json           # plugin versions lockfile
├── stylua.toml              # Lua formatter config
└── lua/
    ├── config/
    │   ├── lazy.lua         # lazy.nvim bootstrap & setup
    │   ├── options.lua      # vim options
    │   ├── keymaps.lua      # custom keymaps
    │   └── autocmds.lua     # custom autocmds
    └── plugins/             # one file per plugin / override
        ├── catppuccin.lua
        ├── minimap.lua
        ├── lsp.lua
        ├── blink.lua
        ├── snacks.lua
        ├── gitsigns.lua
        ├── better-ts-errors.lua
        └── example.lua      # LazyVim starter examples (disabled)
```

## License

[MIT](./LICENSE)
