return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,  -- 显示 . 开头的隐藏文件
          ignored = true, -- 显示 .gitignore 中的文件
          exclude = { "node_modules", ".git" },
        },
        files = {
          hidden = true,  -- 搜索 . 开头的隐藏文件
          ignored = true, -- 搜索 .gitignore 中的文件
          exclude = { "node_modules", ".git" },
        },
      },
    },
  },
}
