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

-- Delete operations
map("i", "<C-d>", "<Del>", { desc = "Delete character forward" })
-- 全局兜底
map("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })

