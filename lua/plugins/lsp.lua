return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- 禁用 LazyVim 默认的 <C-k> signature help（insert mode）
    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].keys = opts.servers["*"].keys or {}
    table.insert(opts.servers["*"].keys, { "<c-k>", false, mode = "i" })

    -- 强制开启 vtsls 变量类型 inlay hints（LazyVim 默认关闭 variableTypes）
    local ts_hints = {
      variableTypes = { enabled = true },
      parameterNames = { enabled = "all" },
      parameterTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    }
    opts.servers.tsgo = opts.servers.tsgo or {}
    opts.servers.tsgo.settings = opts.servers.tsgo.settings or {}
    opts.servers.tsgo.settings.typescript = opts.servers.tsgo.settings.typescript or {}
    opts.servers.tsgo.settings.typescript.inlayHints = vim.tbl_deep_extend(
      "force",
      opts.servers.tsgo.settings.typescript.inlayHints or {},
      ts_hints
    )
    return opts
  end,
}
