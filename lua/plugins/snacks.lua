return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          toggle_node_modules = function(picker)
            local exclude = vim.deepcopy(picker.opts.exclude or {})
            local excluded = vim.tbl_contains(exclude, "node_modules")

            if excluded then
              exclude = vim.tbl_filter(function(pattern)
                return pattern ~= "node_modules"
              end, exclude)
              picker.opts.ignored = true
              vim.notify("node_modules shown", vim.log.levels.INFO)
            else
              table.insert(exclude, "node_modules")
              vim.notify("node_modules hidden", vim.log.levels.INFO)
            end

            picker.opts.exclude = exclude
            picker.list:set_target()
            picker:find()
          end,
        },
        sources = {
          explorer = {
            hidden = true,  -- 显示 . 开头的隐藏文件
            ignored = true, -- 显示 .gitignore 中的文件
            exclude = { "node_modules", ".git" },
            win = {
              list = {
                keys = {
                  ["N"] = "toggle_node_modules",
                },
              },
            },
          },
          files = {
            hidden = true,
            ignored = true,
            exclude = { "node_modules", ".git" },
          },
        },
      },
      terminal = {
        win = {
          keys = {
            -- Keep LazyVim's terminal window-navigation keys available nowhere
            -- in terminal-mode, so the shell receives native Ctrl-H/J/K/L.
            nav_h = false,
            nav_j = false,
            nav_k = false,
            nav_l = false,
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
