local web_filetypes = {
  "astro",
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local biome_roots = { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" }
local oxc_roots = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "vite.config.ts",
  "vite.config.js",
}

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      for _, ft in ipairs(web_filetypes) do
        opts.formatters_by_ft[ft] = function(bufnr)
          if vim.fs.root(bufnr, biome_roots) then
            return { "biome-check" }
          end
          if vim.fs.root(bufnr, oxc_roots) then
            return { "oxfmt" }
          end
          return { "prettier" }
        end
      end
    end,
  },
}
