-- Keep a separate session for every project *and* Git branch, and restore it
-- when Neovim is opened on a directory (for example: `nvim .`).
return {
  "folke/persistence.nvim",
  event = "VimEnter",
  opts = {
    branch = true,
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    -- persistence.nvim normally shares main/master with the branch-less
    -- project session and falls back to that session. Use an exact branch key
    -- instead, so a layout from one branch is never restored on another.
    persistence.current = function(load_opts)
      load_opts = load_opts or {}
      local name = vim.fn.getcwd():gsub("[\\\\/:]+", "%%")
      if load_opts.branch ~= false then
        local branch = persistence.branch()
        if branch and branch ~= "" then
          name = name .. "%%" .. branch:gsub("[\\\\/:]+", "%%")
        end
      end
      return require("persistence.config").options.dir .. name .. ".vim"
    end

    local original_load = persistence.load
    persistence.load = function(load_opts)
      load_opts = load_opts or {}
      -- Preserve the built-in `last = true` behavior for <leader>ql.
      if load_opts.last then
        return original_load(load_opts)
      end

      local session = persistence.current()
      if vim.fn.filereadable(session) == 0 then
        return
      end
      persistence.fire("LoadPre")
      vim.cmd("silent! source " .. vim.fn.fnameescape(session))
      persistence.fire("LoadPost")
    end

    local first_argument = vim.fn.argv(0)
    local opens_directory = vim.fn.argc() == 0 or (first_argument ~= "" and vim.fn.isdirectory(first_argument) == 1)
    if opens_directory then
      vim.schedule(function()
        persistence.load()
      end)
    end
  end,
}
