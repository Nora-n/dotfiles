-- Thanks https://www.ejmastnak.com/tutorials/vim-latex/luasnip/
-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local time = function()
  return { os.date("%H:%M:%S") }
end

-- ls.add_snippets(nil, {
--   all = {
--     s({
--       trig = "time",
--       namr = "time",
--       dscr = "Time in the form of HH-MM-SS",
--     }, {
--       f(time, {}),
--     }),
--   },
-- })

-- return {
--   s({
--     trig = "tmeis",
--     snippetType = "autosnippet",
--     dscr = "Add time",
--   }, {
--     f(time, {}),
--   }),
-- }
