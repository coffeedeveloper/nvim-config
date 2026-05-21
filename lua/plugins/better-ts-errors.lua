return {
  "OlegGulevskyy/better-ts-errors.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  opts = {
    keymaps = {
      toggle = "<leader>dd",
      go_to_definition = "<leader>dx",
    },
  },
}
