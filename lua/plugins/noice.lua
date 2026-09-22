return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = {
        -- Pyright reports indexing/type-checking progress frequently. Keep LSP
        -- diagnostics and completion, but do not show these transient popups.
        enabled = false,
      },
    },
  },
}
