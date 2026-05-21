return {
  {
    "nvim-mini/mini.map",
    version = false,
    keys = {
      { "<leader>mm", function() require("mini.map").toggle() end, desc = "Toggle Minimap" },
    },
    config = function()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
          map.gen_integration.diff(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
        },
        window = {
          focusable = false,
          side = "right",
          show_integration_count = false,
          width = 10,
          winblend = 15,
        },
      })
      vim.schedule(function() map.open() end)
    end,
  },
}
