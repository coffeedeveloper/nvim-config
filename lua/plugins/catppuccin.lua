local function catppuccin_flavour()
  return vim.o.background == "light" and "latte" or "macchiato"
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    init = function()
      vim.g.catppuccin_flavour = catppuccin_flavour()

      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
          vim.g.catppuccin_flavour = catppuccin_flavour()
          if (vim.g.colors_name or ""):find("^catppuccin") then
            vim.schedule(function()
              vim.cmd.colorscheme("catppuccin")
            end)
          end
        end,
      })
    end,
    opts = {
      flavour = "macchiato",
      background = {
        dark = "macchiato",
        light = "latte",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local flavour = catppuccin_flavour()
        vim.g.catppuccin_flavour = flavour
        require("catppuccin").load(flavour)
      end,
    },
  },
}
