-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Change this to another installed macOS app, for example "Typora" or
-- "Visual Studio Code". Obsidian uses its URI scheme; other apps are passed
-- to `open` as a separate argument.
local markdown_external_app = "Visual Studio Code"

local function uri_encode(value)
  return (value:gsub("[^%w%-%._~]", function(char)
    return string.format("%%%02X", string.byte(char))
  end))
end

-- Return false when Obsidian's local vault registry definitively does not
-- contain the file, and nil when the registry cannot be inspected.
local function is_in_obsidian_vault(file)
  local vaults_file = vim.fn.expand("~/Library/Application Support/obsidian/obsidian.json")
  local stat = vim.loop.fs_stat(vaults_file)
  if not stat or stat.type ~= "file" or stat.size > 1024 * 1024 then
    return nil
  end

  local ok, contents = pcall(function()
    local handle = io.open(vaults_file, "r")
    if not handle then
      return nil
    end

    local value = handle:read("*a")
    handle:close()
    return value
  end)
  if not ok or type(contents) ~= "string" then
    return nil
  end

  local decoded, config = pcall(vim.fn.json_decode, contents)
  if not decoded or type(config) ~= "table" or type(config.vaults) ~= "table" then
    return nil
  end

  for _, vault in pairs(config.vaults) do
    if type(vault) == "table" and type(vault.path) == "string" then
      local vault_path = vim.loop.fs_realpath(vault.path)
      local vault_prefix = vault_path and (vault_path .. "/")
      if vault_prefix and (file == vault_path or file:sub(1, #vault_prefix) == vault_prefix) then
        return true
      end
    end
  end

  return false
end

local function current_file_path()
  if vim.bo.buftype ~= "" then
    vim.notify("The current buffer is not a file", vim.log.levels.WARN)
    return nil
  end

  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    vim.notify("The current buffer has no file path", vim.log.levels.WARN)
    return nil
  end

  local absolute_path = vim.fn.fnamemodify(filename, ":p")
  return vim.loop.fs_realpath(absolute_path) or absolute_path
end

local function copy_current_path(relative)
  if vim.fn.has("clipboard") ~= 1 then
    vim.notify("Neovim has no system clipboard provider", vim.log.levels.ERROR)
    return
  end

  local file = current_file_path()
  if not file then
    return
  end

  local value = file
  if relative then
    local root = LazyVim.root()
    local root_path = root and (vim.loop.fs_realpath(root) or vim.fn.fnamemodify(root, ":p"))
    if not root_path then
      vim.notify("Could not determine the project root", vim.log.levels.ERROR)
      return
    end

    root_path = root_path:gsub("/$", "")
    local root_prefix = root_path .. "/"
    if file ~= root_path and file:sub(1, #root_prefix) ~= root_prefix then
      vim.notify("The current file is outside the project root", vim.log.levels.WARN)
      return
    end

    value = vim.fs.relpath(root_path, file)
    if not value or value == "" then
      vim.notify("Could not calculate the project-relative path", vim.log.levels.ERROR)
      return
    end
  end

  vim.fn.setreg("+", value)
  vim.notify(relative and "Copied project-relative path" or "Copied absolute path", vim.log.levels.INFO)
end

-- Open and search the node_modules directory under the current project root.
local function node_modules_scope()
  local root = LazyVim.root()
  if not root or root == "" then
    vim.notify("Could not determine the project root", vim.log.levels.ERROR)
    return
  end

  local root_path = vim.fs.normalize(root)
  local node_modules = vim.fs.joinpath(root_path, "node_modules")
  local stat = (vim.uv or vim.loop).fs_stat(node_modules)
  if not stat or stat.type ~= "directory" then
    vim.notify("No node_modules directory in the project root", vim.log.levels.WARN)
    return
  end

  return root_path, node_modules
end

local function open_node_modules(action)
  local root, node_modules = node_modules_scope()
  if not root or not node_modules then
    return
  end

  local picker_opts = {
    hidden = true,
    ignored = true,
    exclude = { ".git" },
  }

  if action == "explorer" then
    picker_opts.cwd = root
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if explorer then
      explorer:close()
      vim.schedule(function()
        Snacks.explorer(picker_opts)
      end)
    else
      Snacks.explorer(picker_opts)
    end
  elseif action == "files" then
    picker_opts.dirs = { node_modules }
    Snacks.picker.files(picker_opts)
  elseif action == "grep" then
    picker_opts.dirs = { node_modules }
    Snacks.picker.grep(picker_opts)
  end
end

vim.api.nvim_create_user_command("NodeModules", function(opts)
  local action = opts.args == "" and "explorer" or opts.args
  if not vim.tbl_contains({ "explorer", "files", "grep" }, action) then
    vim.notify("Usage: :NodeModules [explorer|files|grep]", vim.log.levels.ERROR)
    return
  end

  open_node_modules(action)
end, {
  nargs = "?",
  complete = function()
    return { "explorer", "files", "grep" }
  end,
  desc = "View or search node_modules in the project root",
  force = true,
})

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

-- Terminal buffers use terminal-mode (`t`), not insert-mode (`i`).
-- Pass macOS/Readline control keys through to the shell unchanged.
local terminal_passthrough_keys = {
  "<C-a>",
  "<C-b>",
  "<C-d>",
  "<C-e>",
  "<C-f>",
  "<C-h>",
  "<C-j>",
  "<C-k>",
  "<C-l>",
  "<C-n>",
  "<C-p>",
  "<C-u>",
  "<C-w>",
}
for _, key in ipairs(terminal_passthrough_keys) do
  map("t", key, key, { desc = "Pass through to terminal" })
end

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

map("n", "<leader>yP", function()
  copy_current_path(false)
end, { desc = "Copy Absolute File Path" })

map("n", "<leader>yp", function()
  copy_current_path(true)
end, { desc = "Copy Project-Relative File Path" })

map("n", "<leader>fN", function()
  open_node_modules("files")
end, { desc = "Find Files (node_modules)" })

map("n", "<leader>sN", function()
  open_node_modules("grep")
end, { desc = "Grep (node_modules)" })

-- Delete operations
map("i", "<C-d>", "<Del>", { desc = "Delete character forward" })
-- 全局兜底
map("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })

-- Open the current project root in an external editor (macOS `open -a`).
local function open_project_in(app)
  if vim.fn.has("mac") ~= 1 then
    vim.notify("Opening projects in external apps currently supports macOS only", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("open") ~= 1 then
    vim.notify("The macOS `open` command is unavailable", vim.log.levels.ERROR)
    return
  end

  -- Verify the target app is installed before launching it.
  vim.fn.system({ "open", "-Ra", app })
  if vim.v.shell_error ~= 0 then
    vim.notify(app .. " is not installed", vim.log.levels.ERROR)
    return
  end

  local root = LazyVim.root()
  if not root or root == "" then
    vim.notify("Could not determine the project root", vim.log.levels.ERROR)
    return
  end

  local dir = vim.fs.normalize(root)
  local job_id = vim.fn.jobstart({ "open", "-a", app, dir }, { detach = true })
  if job_id <= 0 then
    vim.notify("Could not open " .. dir .. " in " .. app, vim.log.levels.ERROR)
    return
  end

  vim.notify("Opening project in " .. app, vim.log.levels.INFO)
end

map("n", "<leader>pc", function()
  open_project_in("Visual Studio Code")
end, { desc = "Open Project in VS Code" })

map("n", "<leader>pw", function()
  open_project_in("WebStorm")
end, { desc = "Open Project in WebStorm" })

map("n", "<leader>pz", function()
  open_project_in("Zed")
end, { desc = "Open Project in Zed" })

-- Open the current Markdown file in an external macOS app.
map("n", "<leader>mo", function()
  if vim.bo.buftype ~= "" then
    vim.notify("The current buffer is not a file", vim.log.levels.WARN)
    return
  end

  local filename = vim.api.nvim_buf_get_name(0)
  local extension = vim.fn.fnamemodify(filename, ":e"):lower()
  if extension ~= "md" then
    vim.notify("The current buffer is not a Markdown file", vim.log.levels.WARN)
    return
  end

  local file = vim.loop.fs_realpath(filename)
  if not file or vim.fn.filereadable(file) ~= 1 then
    vim.notify("The current Markdown file is not readable", vim.log.levels.ERROR)
    return
  end

  if vim.fn.has("mac") ~= 1 then
    vim.notify("<leader>mo currently supports macOS only", vim.log.levels.ERROR)
    return
  end

  local app = vim.trim(markdown_external_app)
  if app == "" then
    vim.notify("Set markdown_external_app to an installed app", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("open") ~= 1 then
    vim.notify("The macOS `open` command is unavailable", vim.log.levels.ERROR)
    return
  end

  local command
  if app:lower() == "obsidian" then
    if is_in_obsidian_vault(file) == false then
      vim.notify(
        "Obsidian can only open files inside a registered vault; choose another app or add this folder as a vault",
        vim.log.levels.ERROR
      )
      return
    end

    -- Obsidian handles note navigation through its URI scheme. The regular
    -- `open -a Obsidian <file>` call only activates an existing window.
    command = { "open", "obsidian://open?path=" .. uri_encode(file) }
  else
    -- Verify the target app is installed before launching it.
    vim.fn.system({ "open", "-Ra", app })
    if vim.v.shell_error ~= 0 then
      vim.notify(app .. " is not installed", vim.log.levels.ERROR)
      return
    end

    command = { "open", "-a", app, file }
  end

  local job_id = vim.fn.jobstart(command, { detach = true })
  if job_id <= 0 then
    vim.notify("Could not open the Markdown file in " .. app, vim.log.levels.ERROR)
    return
  end

  vim.notify("Sent Markdown file to " .. app, vim.log.levels.INFO)
end, { desc = "Open Markdown in External App" })
