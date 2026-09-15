-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_open_in_vscode", { clear = true }),
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("n", "<leader>mo", function()
      local path = vim.api.nvim_buf_get_name(event.buf)
      if path == "" then
        vim.notify("Save the Markdown file before opening it in VS Code.", vim.log.levels.WARN)
        return
      end
      vim.fn.jobstart({ "open", "-a", "Visual Studio Code", path }, { detach = true })
    end, { buffer = event.buf, desc = "Open Markdown in VS Code" })
  end,
})
