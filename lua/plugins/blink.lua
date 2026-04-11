return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      -- 默认 preset 里 <C-n>/<C-p> 已经用 fallback_to_mappings，
      -- 补全菜单不可见时会自动触发 keymaps.lua 里的 <Down>/<Up>，无需额外配置。

      -- 将 fallback 改为 fallback_to_mappings，使 keymaps.lua 里的 macOS 快捷键生效：
      -- <C-e>: 有补全时 cancel，否则触发 <End>（keymaps.lua）
      ["<C-e>"] = { "cancel", "fallback_to_mappings" },
      -- <C-k>: 不再绑定 signature help，直接交给 keymaps.lua 的 kill-to-EOL
      ["<C-k>"] = {},
      -- <C-b>/<C-f>: 文档 popup 可见时滚动，否则触发 <Left>/<Right>（keymaps.lua）
      ["<C-b>"] = { "scroll_documentation_up", "fallback_to_mappings" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback_to_mappings" },

      -- 用 Enter 接受补全（菜单不可见时正常换行）
      ["<CR>"] = { "accept", "fallback" },
      -- Tab 直接接受当前高亮项（VSCode 风格），同时支持 snippet 跳转
      ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}
