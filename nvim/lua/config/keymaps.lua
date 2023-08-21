-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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
vim.keymap.set(
  "n",
  "jk",
  "<cmd>w<cr>",
  { noremap = true, desc = "Save window" }
)
vim.keymap.set(
  "n",
  "kj",
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
  "<leader>aa",
  ":Tabularize /",
  { noremap = true, desc = "Tab enter" }
)
vim.keymap.set(
  "v",
  "<leader>aa",
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
vim.keymap.set(
  "n",
  "<C-S-p>",
  "<cmd>term python % <CR>",
  -- "<cmd>sp <CR> <cmd>term python % <CR>",
  { noremap = true, desc = "Launch Python" }
)
vim.keymap.set(
  "n",
  "<C-p>",
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

vim.keymap.set(
  "n",
  "<Leader>L",
  '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})<CR>',
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