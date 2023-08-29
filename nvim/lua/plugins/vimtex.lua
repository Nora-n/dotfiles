return {
  {
    "lervag/vimtex",
    ft = "tex", -- without ft, it's not working too
    lazy = false,
    config = function()
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_flavor = "latex"
      vim.g.tex_conceal = "abdmg"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_view_method = "zathura"
      vim.g.latex_view_general_viewer = "zathura"
      vim.g.vimtex_split_pos = "vert rightabove"
      vim.g.vimtex_split_width = "20"
      vim.cmd("call vimtex#init()")
    end,
  },
  {
    "LazyVim/LazyVim",
  },
}
