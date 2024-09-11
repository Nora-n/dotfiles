-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- vim.cmd([[
-- " Latex specification
-- au BufNewFile,BufRead *.tex
--     \ set nocursorline |
--     \ set nornu |
--     \ set number |
--     \ let g:loaded_matchparen=1 |
-- ]])
-- treesitter for vimwiki: :InspectTree
-- vim.treesitter.language.register("markdown", "vimwiki")
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "calendar",
  },
  callback = function()
    vim.opt_local.number = false
  end,
})

-- firenvim FileTypes
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "localhost_*.txt",
  command = "set filetype=python",
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "localhost_*.txt",
  command = [[:%s!\v^(\s*\r?\n){2,}!\r]],
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*ipynb_ontainer-DIV*.txt",
  command = "set filetype=markdown",
})

-- set overleaf to latex
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = "*overleaf*",
--   command = "set filetype=latex",
-- })

-- vim.cmd([[
-- let l:bufname=expand('%:t')
-- if l:bufname =~? 'overleaf.com'
--     set ft=tex
-- endif
-- ]])

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {
--     "tex",
--   },
--   callback = function()
--     vim.opt_local.foldenable = false
--   end,
-- })
