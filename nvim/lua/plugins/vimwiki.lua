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
      vim.g.vimwiki_folding = "list:quick"
    end,
  },
}
