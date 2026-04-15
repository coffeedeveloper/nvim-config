return {
  {
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
            hidden = true,
            ignored = true,
            exclude = { "node_modules", ".git" },
          },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
}
