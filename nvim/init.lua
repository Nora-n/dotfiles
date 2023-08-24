-- use space as localleader too
-- vim.g.mapleader = "<Space>"
vim.g.maplocalleader = " "

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Color
require("onedark").setup({
  style = "darker",
})
require("onedark").load()

-- set colorbar at 80 char
vim.o.colorcolumn = "80"
-- set wrap
vim.o.wrap = true
vim.o.textwidth = 80
vim.o.conceallevel = 0
-- set chgdir
vim.o.autochdir = true
-- search automatically global
vim.o.gdefault = true
-- see multiple spaces as tabstops so <BS> does the right thing?
vim.o.softtabstop = 2

-- for autosnippets in luasnip
require("luasnip").config.set_config({ -- Setting LuaSnip config
  -- Enable autotriggered snippets
  enable_autosnippets = true,
  update_events = "TextChanged,TextChangedI",
  store_selection_keys = "<Tab>",
})
-- Load snippets from ~/.config/nvim/snippets/
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip.loaders.from_vscode").load({
  paths = { "~/.config/nvim/snippets/" },
})

-- local luasnip_fix_augroup =
--   vim.api.nvim_create_augroup("MyLuaSnipHistory", { clear = true })
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   pattern = "*",
--   callback = function()
--     if
--       (
--         (vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n")
--         or vim.v.event.old_mode == "i"
--       )
--       and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
--       and not require("luasnip").session.jump_active
--     then
--       require("luasnip").unlink_current()
--     end
--   end,
--   group = luasnip_fix_augroup,
-- })

vim.cmd([[
augroup mytex | au!
    autocmd FileType tex setlocal nofixeol
augroup end
]])

vim.cmd([[
" Reformat lines (getting the spacing correct) {{{
fun! TeX_fmt()
    if (getline(".") != "")
    let save_cursor = getpos(".")
        let op_wrapscan = &wrapscan
        set nowrapscan
        let par_begin = '^\(%D\)\=\s*\($\|\\begin\|\\end\|\\\[\|\\\]\|\\\(sub\)*section\>\|\\item\>\|\\litem\>\|\\clitem\>\|\\sqlitem\>\|\\nitem\>\|\\NC\>\|\\blank\>\|\\noindent\>\|\\smallbreak\>\|\\bigbreak\>\|\\label\>\|\\hfill\>\)'
        let par_end   = '^\(%D\)\=\s*\($\|\\begin\|\\end\|\\\]\|\\\[\|\\place\|\\\(sub\)*section\>\|\\item\>\|\\litem\>\|\\clitem\>\|\\sqlitem\>\|\\nitem\>\|\\NC\>\|\\blank\>\|\\smallbreak\>\|\\bigbreak\>\|\\label\>\|\\hfill\>\)'
    try
      exe '?'.par_begin.'?+'
    catch /E384/
      1
    endtry
        norm V
    try
      exe '/'.par_end.'/-'
    catch /E385/
      $
    endtry
    norm gq
        let &wrapscan = op_wrapscan
    call setpos('.', save_cursor)
    endif
endfun

nmap Q :call TeX_fmt()<CR>
" }}}
]])
