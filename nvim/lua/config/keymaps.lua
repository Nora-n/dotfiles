-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- change lazy shortcut
-- vim.keymap.del("n", "<leader>l")
-- vim.keymap.set("n", "<leader>lL", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- open init.lua
vim.keymap.set(
  "n",
  "<leader>Oc",
  "<cmd>e ~/.config/nvim/init.lua<cr>",
  { desc = "Open config" }
)
vim.keymap.set(
  "n",
  "<leader>Sc",
  "<cmd>luafile %<cr>",
  { desc = "Source config" }
)

-- new line above and below
vim.keymap.set("n", "<leader>o", "o<ESC>O", { desc = "Line above below" })

-- Save file
-- vim.keymap.del("n", "<leader><Space>")
vim.keymap.set(
  "n",
  "zl",
  -- "<leader><Space>",
  "<cmd>w<cr>",
  { noremap = true, desc = "Save window" }
)
vim.keymap.set(
  "n",
  "zh",
  "u<cmd>w<cr>",
  { noremap = true, desc = "Undo and save window" }
)

-- Spelling
vim.keymap.set(
  "n",
  "<F3>",
  "<cmd>set invspell<cr>",
  { noremap = true, desc = "Toggle spelling" }
)
vim.keymap.set(
  "n",
  "<F4>",
  "<cmd>set spelllang=fr<cr>",
  { noremap = true, desc = "Spell french" }
)
vim.keymap.set(
  "n",
  "<F5>",
  "<cmd>set spelllang=en<cr>",
  { noremap = true, desc = "Spell english" }
)

-- Filetypes
vim.keymap.set(
  "n",
  "<F2>",
  "<Cmd>set filetype=markdown<CR>",
  { desc = "ft md" }
)

vim.keymap.set("n", "<F1>", "<Cmd>set filetype=tex<CR>", { desc = "ft tex" })

vim.keymap.set(
  "n",
  "<S-F1>",
  "<Cmd>set filetype=python<CR>",
  { desc = "ft py" }
)

-- Tabular
vim.keymap.set(
  "n",
  "<leader>a=",
  "<cmd>Tabularize /=<cr>",
  { noremap = true, desc = "Tab =" }
)
vim.keymap.set(
  "v",
  "<leader>a=",
  "<cmd>Tabularize /=<cr>",
  { noremap = true, desc = "Tab =" }
)
vim.keymap.set(
  "n",
  "<leader>a:",
  "<cmd>Tabularize /:<cr>",
  { noremap = true, desc = "Tab :" }
)
vim.keymap.set(
  "v",
  "<leader>a:",
  "<cmd>Tabularize /:<cr>",
  { noremap = true, desc = "Tab :" }
)
vim.keymap.set(
  "n",
  "<leader>a&",
  "<cmd>Tabularize /&<cr>",
  { noremap = true, desc = "Tab &" }
)
vim.keymap.set(
  "v",
  "<leader>a&",
  "<cmd>Tabularize /&<cr>",
  { noremap = true, desc = "Tab &" }
)
vim.keymap.set(
  "n",
  "<leader>aA",
  ":Tabularize /",
  { noremap = true, desc = "Tab enter" }
)
vim.keymap.set(
  "v",
  "<leader>aA",
  ":Tabularize /",
  { noremap = true, desc = "Tab enter" }
)

-- change tab nav
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

vim.keymap.set("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set(
  "n",
  "<leader><tab><tab>",
  "<cmd>tabnew<cr>",
  { desc = "New Tab" }
)
vim.keymap.set(
  "n",
  "<leader><tab>h",
  "<cmd>tabprevious<cr>",
  { desc = "Previous Tab" }
)
vim.keymap.set("n", "<leader><tab>j", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set(
  "n",
  "<leader><tab>k",
  "<cmd>tabfirst<cr>",
  { desc = "First Tab" }
)
vim.keymap.set(
  "n",
  "<leader><tab>q",
  "<cmd>tabclose<cr>",
  { desc = "Close tab" }
)

-- Launch Python
-- vim.keymap.set(
--   "n",
--   "<C-S-p>",
--   "<cmd>term python % <CR>",
--   -- "<cmd>sp <CR> <cmd>term python % <CR>",
--   { noremap = true, desc = "Launch Python" }
-- )
vim.keymap.set(
  "n",
  "<C-S-p>",
  "<cmd>!python3 %<CR>",
  { noremap = true, desc = "Float Python" }
)

-- snippets
-- vim.keymap.del({ "i", "s" }, "<tab>")
-- vim.keymap.del({ "i", "s" }, "<s-tab>")
-- vim.cmd([[
-- " Use alt+e to expand snippets
-- imap <silent><expr> <A-e> luasnip#expandable() ? '<Plug>luasnip-expand-snippet' : '<A-e>'
-- " Use jk to jump forward through snippets
-- imap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
-- smap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
-- " Use kj to jump backwards through snippets
-- imap <silent><expr> kj luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'kj'
-- smap <silent><expr> kj luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'kj'
-- ]])

-- format latex
vim.keymap.set(
  "n",
  "Q",
  "<Plug>latexfmt_format",
  { noremap = true, desc = "Format LaTeX" }
)

-- reload snippets
vim.keymap.set(
  "n",
  "<Leader>L",
  '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})<CR><Cmd>lua require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/snippets/"})<CR>',
  { desc = "Reload snippets" }
)

local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

-- open vimwiki
vim.keymap.set("n", "<Leader>ww", "<Plug>VimwikiIndex", { desc = "Open index" })

-- DiffviewFileHistory
-- vim.keymap.del("n", "<Leader>d")
vim.keymap.set(
  "n",
  "<Leader>df",
  "<Cmd>DiffviewFileHistory %<CR>",
  { desc = "Diffview current file" }
)
vim.keymap.set(
  "n",
  "<Leader>dF",
  "<Cmd>DiffviewFileHistory <CR>",
  { desc = "Diffview current repo" }
)

-- switch boxes to new
vim.keymap.set(
  "n",
  "<Leader>Sba",
  "<Cmd>%s!\\vbegin\\zs\\{(NC|)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}\\3(\\2)<CR><Cmd>%s!\\vend\\zs\\{(NC|)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}!{tcb}<CR>",
  { desc = "Change old boxes" }
)
vim.keymap.set(
  "n",
  "<Leader>Sbl",
  "<Cmd>%s!\\vbegin\\zs\\{l(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}\\2(\\1)<rgt>'r'<CR><Cmd>%s!\\vend\\zs\\{l(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}!{tcb}<CR>",
  { desc = "Change new boxes l" }
)
vim.keymap.set(
  "n",
  "<Leader>Sbr",
  "<Cmd>%s!\\vbegin\\zs\\{(r)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}\\3(\\2)<lft>'l'<CR><Cmd>%s!\\vend\\zs\\{(r|t|b)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}<CR>",
  { desc = "Change new boxes r" }
)
vim.keymap.set(
  "n",
  "<Leader>Sbb",
  "<Cmd>%s!\\vbegin\\zs\\{(t|b)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}\\3(\\2)<CR><Cmd>%s!\\vend\\zs\\{(r|t|b)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)\\}(\\[.*\\]|)!{tcb}<CR>",
  { desc = "Change new boxes" }
)

-- %s!\vbegin\zs{(NC|)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)}([.*])!{tcb}\3(\2)
-- %s!\vend\zs{(NC|)(loi|theo|prop|demo|coro|inte|impl|impo|rapp|defi|nota|ror|exem|odgr|rema)}!{tcb}
