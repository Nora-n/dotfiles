return {
  {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/Documents/wiki/",
          path_html = "~/Documents/wiki/html/",
        },
        {
          path = "~/Documents/worki/",
          path_html = "~/Documents/worki/html/",
        },
      }
      vim.g.vimwiki_hl_headers = 1 -- use alternating colours for different heading levels
      vim.g.indentLine_conceallevel = 2 -- indentline controlls concel
      vim.g.vimwiki_hl_cb_checked = 1 --Change checked list item to grey italic
      vim.g.calendar_monday = 1 --make calendar start on mondays
      vim.g.calendar_options = "nornu" --allow calendar to be full width
      vim.g.calendar_number_of_months = 6 --pretty much self explanatory lol
    end,
  },
}
