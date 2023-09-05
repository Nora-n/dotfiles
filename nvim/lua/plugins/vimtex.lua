return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.tex_conceal = "abdmg"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      -- vim.g.vimtex_compiler_engine = "lualatex"
      vim.g.latex_view_general_viewer = "zathura"
      vim.g.maplocalleader = " "
      vim.g.vimtex_toc_config = {
        split_pos = "vert rightbelow",
        split_width = 38,
      }
    end,
  },
}
