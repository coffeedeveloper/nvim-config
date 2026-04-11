return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- 禁用 LazyVim 默认的 <C-k> signature help（insert mode）
          { "<c-k>", false, mode = "i" },
        },
      },
    },
  },
}
