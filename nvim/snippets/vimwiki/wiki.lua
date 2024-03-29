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

return {
  -- colors
  s(
    {
      trig = "@j",
      snippetType = "autosnippet",
      dscr = "Add yellow",
    },
    fmta([[~~<>~~]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "@r",
      snippetType = "autosnippet",
      dscr = "Add red",
    },
    fmta([[*<>*]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "@p",
      snippetType = "autosnippet",
      dscr = "Add purple",
    },
    fmta([[_*<>*_]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "@b",
      snippetType = "autosnippet",
      dscr = "Add blue",
    },
    fmta([[_<>_]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "@o",
      snippetType = "autosnippet",
      dscr = "Add orange",
    },
    fmta([[$<>$]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "@v",
      snippetType = "autosnippet",
      dscr = "Add time",
    },
    fmta([[`<>`]], {
      d(1, get_visual),
    })
  ),
  -- not auto
  s(
    {
      trig = "jj",
      dscr = "Add yellow",
    },
    fmta([[~~<>~~]], {
      i(1),
    })
  ),
  s(
    {
      trig = "rr",
      dscr = "Add red",
    },
    fmta([[*<>*]], {
      i(1),
    })
  ),
  s(
    {
      trig = "pp",
      dscr = "Add purple",
    },
    fmta([[_*<>*_]], {
      i(1),
    })
  ),
  s(
    {
      trig = "bb",
      dscr = "Add blue",
    },
    fmta([[_<>_]], {
      i(1),
    })
  ),
  s(
    {
      trig = "oo",
      dscr = "Add orange",
    },
    fmta([[$<>$]], {
      i(1),
    })
  ),
  s(
    {
      trig = "vv",
      dscr = "Add time",
    },
    fmta([[`<>`]], {
      i(1),
    })
  ),
  -- diary
  s(
    {
      trig = "diary",
      dscr = "Add diary entry",
    },
    fmta("~~<> [[diary:<>-<>-<>]]~~", {
      d(1, get_visual),
      c(2, { t("2024"), t("2025"), t("2023") }),
      i(3, "MM"),
      i(4, "JJ"),
    })
  ),
  -- url
  s(
    {
      trig = "url",
      dscr = "Add url",
    },
    fmta("[[<>|<>]]", {
      i(1, "URL"),
      d(2, get_visual),
    })
  ),
  -- headers
  s({
    trig = "hd",
    snippetType = "autosnippet",
    dscr = "Header",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
            = <> =
            <>
            ]],
        { i(1), i(0) }
      ),
      fmta(
        [[
            == <> ==
            <>
            ]],
        { i(1), i(0) }
      ),
      fmta(
        [[
            === <> ===
            <>
            ]],
        { i(1), i(0) }
      ),
      fmta(
        [[
            ==== <> ====
            <>
            ]],
        { i(1), i(0) }
      ),
      fmta(
        [[
            ===== <> =====
            <>
            ]],
        { i(1), i(0) }
      ),
      fmta(
        [[
            ====== <> ======
            <>
            ]],
        { i(1), i(0) }
      ),
    }),
  }),
}
