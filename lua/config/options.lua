-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Let Conform select exactly one project formatter. ESLint remains enabled for diagnostics.
vim.g.lazyvim_eslint_auto_format = false

-- Keep spell checking useful for documentation by accepting project and tooling names.
vim.opt.spelloptions:append("camel")
local spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local spellfile_compiled = spellfile .. ".spl"
local source = vim.uv.fs_stat(spellfile)
local compiled = vim.uv.fs_stat(spellfile_compiled)
local needs_compile = source and (
  not compiled
  or source.mtime.sec > compiled.mtime.sec
  or (source.mtime.sec == compiled.mtime.sec and source.mtime.nsec > compiled.mtime.nsec)
)
if needs_compile then
  vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(spellfile))
end
vim.opt.spellfile = { spellfile }
