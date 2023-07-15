return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {},
    opts = {
      history = true,
      region_check_events = "CursorHold,InsertLeave",
      delete_check_events = "TextChanged,InsertEnter",
    },
    keys = {
      { "<tab>", false },
      { "<s-tab>", false },
      -- {
      --   "jk",
      --   function()
      --     return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next"
      --       or "jk"
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = { "i", "s" },
      -- },
      -- {
      --   "kj",
      --   function()
      --     return require("luasnip").jumpable(-1) and "<Plug>luasnip-jump-prev"
      --       or "kj"
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = { "i", "s" },
      -- },
      -- {
      --   "<A-e>",
      --   function()
      --     require("luasnip").expandable()
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = "i",
      -- },
    },
  },
}
