-- nvim-cmp configs
return {
  -- customize nvim-cmp configs
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end

      local cmp = require("cmp")

      -- This is reaaaally not easy to setup :D
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- if the completion pop is visible then complete
          if cmp.visible() then
            cmp.confirm({ select = false })
            -- if not jumpable and popup not visible then open the popup
          elseif has_words_before() then
            cmp.complete()
            -- otherwise fallback
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
