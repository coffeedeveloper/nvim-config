return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- Neovim identifies *.sh buffers as `sh`, while the Tree-sitter
      -- grammar is named `bash`.
      vim.treesitter.language.register("bash", "sh")
    end,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" and not vim.tbl_contains(opts.ensure_installed, "bash") then
        table.insert(opts.ensure_installed, "bash")
      end
    end,
  },
}
