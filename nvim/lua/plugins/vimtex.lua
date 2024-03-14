return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.tex_fold_enabled = 0
      vim.g.vimtex_fold_enabled = 0
      vim.g.vimtex_syntax_enabled = 1
      -- vim.g.vimtex_delim_stopline = 100
      vim.g.vimtex_syntax_conceal = {
        spacing = 0,
        ligatures = 0,
        math_bounds = 0,
        math_symbols = 1,
        sections = 1,
      }
      -- vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      -- vim.g.vimtex_compiler_engine = "lualatex"
      vim.g.latex_view_general_viewer = "zathura"
      -- vim.g.maplocalleader = " "
      vim.g.vimtex_toc_config = {
        split_pos = "vert rightbelow",
        split_width = 39,
      }
      vim.g.vimtex_format_enabled = 1
    end,
  },
}
