-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- macOS / Emacs-style editing shortcuts in insert mode
-- Line start / end
map("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })

-- Character navigation
map("i", "<C-f>", "<Right>", { desc = "Move forward one char" })
map("i", "<C-b>", "<Left>", { desc = "Move backward one char" })

-- Line navigation (blink.cmp 在补全菜单未显示时会通过 fallback_to_mappings 触发这两个)
map("i", "<C-n>", "<Down>", { desc = "Next line" })
map("i", "<C-p>", "<Up>", { desc = "Previous line" })

-- Vertical terminal (right split)
map("n", "<leader>fv", function()
  local count = vim.v.count ~= 0 and vim.v.count or 1
  Snacks.terminal(nil, { id = count, cwd = LazyVim.root(), win = { position = "right" } })
end, { desc = "Terminal Vertical (Root Dir)" })

-- Review the current Git working tree in Hunk, using the same floating layout as LazyGit.
map("n", "<leader>gH", function()
  if vim.fn.executable("hunk") ~= 1 then
    vim.notify("Hunk CLI is not installed or not available on PATH", vim.log.levels.ERROR)
    return
  end

  Snacks.terminal({ "hunk", "diff", "HEAD" }, { cwd = LazyVim.root.git(), win = { style = "lazygit" } })
end, { desc = "Hunk Diff (Root Dir)" })

-- Delete operations
map("i", "<C-d>", "<Del>", { desc = "Delete character forward" })
-- 全局兜底
map("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })

-- Copy absolute file path
map("n", "<leader>yP", function()
  local path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg("+", path)
  vim.notify(path)
end, { desc = "Copy Absolute Path" })

-- Copy file path relative to project root
map("n", "<leader>yp", function()
  local path = vim.api.nvim_buf_get_name(0)
  local root = LazyVim.root()
  local relative = vim.fs.relpath(root, path) or path
  vim.fn.setreg("+", relative)
  vim.notify(relative)
end, { desc = "Copy Relative Path" })
