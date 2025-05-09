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

-- Some LaTeX-specific conditional expansion functions (requires VimTeX)
local tex_utils = {}
tex_utils.in_mathzone = function() -- math context detection
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function() -- comment detection
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end
tex_utils.in_env = function(name) -- generic environment detection
  local is_inside = vim.fn["vimtex#env#is_inside"](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function() -- equation environment detection
  return tex_utils.in_env("equation")
end
tex_utils.in_itemize = function() -- itemize environment detection
  return tex_utils.in_env("itemize")
end
tex_utils.in_tikz = function() -- TikZ picture environment detection
  return tex_utils.in_env("tikzpicture")
end

-- This is the `get_visual` function I've been talking about.
-- ----------------------------------------------------------------------------
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
-- ----------------------------------------------------------------------------

return {
  -----------------------------------------------------------------------------
  -- utils
  -----------------------------------------------------------------------------
  -- usepackage
  s({
    trig = "usp",
    snippetType = "autosnippet",
    dscr = "usepackage",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
      \usepackage{<>}
      <>
    ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \usepackage[<>]{<>}
      <>
    ]],
        {
          i(1),
          d(2, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -- newcommand
  s(
    {
      trig = "nwc",
      snippetType = "autosnippet",
      dscr = "newcommand",
      condition = line_begin,
    },
    fmta(
      [[
      \newcommand{<>}<>{
      <>
      }
      <>
    ]],
      {
        i(1),
        c(2, { t(""), fmta("[<>]", { i(1) }) }),
        d(3, get_visual),
        i(0),
      }
    )
  ),
  -- spaces
  -- smallbreak
  s({
    trig = "smb",
    snippetType = "autosnippet",
    dscr = "smallbreak",
    condition = line_begin,
  }, { t("\\smallbreak") }),
  -- newpage
  s(
    {
      trig = "nwp",
      snippetType = "autosnippet",
      dscr = "newpage",
      condition = line_begin,
    },
    fmta(
      [[
      \newpage
      <>
      ]],
      { i(0) }
    )
  ),
  -- bigbreak
  s({
    trig = "bgb",
    snippetType = "autosnippet",
    dscr = "bigbreak",
    condition = line_begin,
  }, { t("\\bigbreak") }),
  -- vspace
  s(
    {
      trig = "vsp",
      snippetType = "autosnippet",
      dscr = "vspace",
      condition = line_begin,
    },
    fmta(
      [[
      \vspace{<>pt}
      <>
    ]],
      {
        i(1, "-15"),
        i(0),
      }
    )
  ),
  -- for item
  s(
    {
      trig = "lvv",
      snippetType = "autosnippet",
      dscr = "leavevmode",
      condition = line_begin,
    },
    fmta(
      [[
      \leavevmode\vspace*{-<>pt}\relax
      <>
    ]],
      {
        i(1, "15"),
        i(0),
      }
    )
  ),
  -- hspace
  s(
    {
      trig = "hsp",
      snippetType = "autosnippet",
      dscr = "hspace",
      condition = line_begin,
    },
    fmta(
      [[
      \hspace<>{<>pt}
      <>
    ]],
      {
        c(1, { t(""), t("*") }),
        i(2),
        i(0),
      }
    )
  ),
  -- vfill
  s(
    {
      trig = "vfl",
      snippetType = "autosnippet",
      dscr = "vfill",
      condition = line_begin,
    },
    fmta(
      [[
      \vfill<>
      <>
    ]],
      {
        c(1, { t(""), t("*") }),
        i(0),
      }
    )
  ),
  -- hfill
  s(
    {
      trig = "hfl",
      snippetType = "autosnippet",
      dscr = "hfill",
      condition = line_begin,
    },
    fmta(
      [[
      \hfill<>
      <>
    ]],
      {
        c(1, { t(""), t("*") }),
        i(0),
      }
    )
  ),
  -- noindent
  s(
    {
      trig = "ndt",
      snippetType = "autosnippet",
      dscr = "noindent",
      condition = line_begin,
    },
    fmta(
      [[
      \noindent
      <>
    ]],
      {
        i(0),
      }
    )
  ),
  -- footnote
  s({
    trig = "ftn",
    snippetType = "autosnippet",
    dscr = "footnote",
    wordTrig = false,
  }, fmta([[\ftn{<>}]], { d(1, get_visual) })),
  -- url
  s({
    trig = "url",
    snippetType = "autosnippet",
    dscr = "url",
  }, fmta([[\url{<>}]], { d(1, get_visual) })),
  -- href
  s({
    trig = "href",
    snippetType = "autosnippet",
    dscr = "href",
  }, fmta([[\href{<>}{<>}]], { d(1, get_visual), i(2, "texte") })),
  -----------------------------------------------------------------------------
  -- Fonts
  -----------------------------------------------------------------------------
  -- Italic
  s({
    trig = "txt",
    snippetType = "autosnippet",
    dscr = "Expands 'txt' into LaTeX's text{} command.",
  }, fmta("\\text{<>}", { d(1, get_visual) })),
  s({
    trig = "xit",
    snippetType = "autosnippet",
    dscr = "Expands 'xit' into LaTeX's textit{} command.",
  }, fmta("\\textit{<>}", { d(1, get_visual) })),
  s({
    trig = "xul",
    snippetType = "autosnippet",
    dscr = "Expands 'xul' into LaTeX's underline{} command.",
  }, fmta("\\ul{<>}", { d(1, get_visual) })),
  -- texttt
  s({
    trig = "xtt",
    snippetType = "autosnippet",
    dscr = "Expands 'xtt' into '\texttt{}'",
  }, fmta("\\texttt{<>}", { d(1, get_visual) })),
  -- textsc
  s({
    trig = "xsc",
    snippetType = "autosnippet",
    dscr = "Expands 'xsc' into '\textsc{}'",
  }, fmta("\\textsc{<>}", { d(1, get_visual) })),
  -- textsc
  s({
    trig = "xbf",
    snippetType = "autosnippet",
    dscr = "Expands 'xbf' into '\textbf{}'",
  }, fmta("\\textbf{<>}", { d(1, get_visual) })),
  -- intertext in math
  s({
    trig = "inx",
    snippetType = "autosnippet",
    dscr = "Expands 'inx' into LaTeX's intertext{} command.",
    condition = tex_utils.in_mathzone,
  }, fmta("\\intertext{<>}", { d(1, get_visual) })),
  -- beforetext in math
  s({
    trig = "bfx",
    snippetType = "autosnippet",
    dscr = "Expands 'bfx' into beforetext{} command.",
    condition = tex_utils.in_mathzone,
  }, fmta("\\beforetext{<>}", { d(1, get_visual) })),
  -- tag in equation
  s({
    trig = "tgg",
    snippetType = "autosnippet",
    dscr = "Expands 'tgg' into tag{} command.",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta([[\tag{<>}]], { d(1, get_visual) }),
      fmta([[\tag*{<>}]], { d(1, get_visual) }),
    }),
  }),
  -- studonly
  s(
    {
      trig = "ifs",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'ifs' into '\\ifstudent{<>}'",
    },
    fmta(
      [[
      \ifstudent{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "Ifs",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'ifs' into '\\ifstudent{<>}'",
    },
    fmta(
      [[
      \ifstudent{<>}<>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "Ifp",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'ifp' into '\\ifprof{<>}'",
    },
    fmta(
      [[
      \ifprof{<>}<>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "ifp",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'ifp' into '\\ifprof{<>}'",
    },
    fmta(
      [[
      \ifprof{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- QR
  s(
    {
      trig = "QR",
      snippetType = "autosnippet",
      dscr = "Expands 'QR' into '\\QR{<>}{<>}'",
      condition = line_begin,
    },
    fmta(
      [[
      \QR{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2, "solu"),
        i(0),
      }
    )
  ),
  -- switch
  s(
    {
      trig = "swt",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'swt' into '\\sswitch{<>}{<>}'",
    },
    fmta(
      [[
      \sswitch{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2, "prof"),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "Swt",
      wordTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'Swt' into '\\sswitch{<>}{<>}'",
    },
    fmta(
      [[
      \sswitch{<>}{<>}<>
      ]],
      {
        d(1, get_visual),
        i(2, "prof"),
        i(0),
      }
    )
  ),
  -- cswitch
  s(
    {
      trig = "csw",
      snippetType = "autosnippet",
      dscr = "Expands 'csw' into '\\cswitch{<>}{<>}'",
    },
    fmta(
      [[
      \cswitch{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2, "énoncé"),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "Csw",
      snippetType = "autosnippet",
      dscr = "Expands 'Csw' into '\\cswitch{<>}{<>}'",
    },
    fmta([[\cswitch{<>}{<>}<>]], {
      d(1, get_visual),
      i(2, "énoncé"),
      i(0),
    })
  ),
  s(
    {
      trig = "crls",
      snippetType = "autosnippet",
      dscr = "Expands 'crls' into '\\crls{<>}'",
    },
    fmta([[\crls{<>}<>]], {
      d(1, get_visual),
      i(0),
    })
  ),
  -- highlight switch white
  -- s(
  --   {
  --     trig = "hsw",
  --     wordTrig = true,
  --     snippetType = "autosnippet",
  --     dscr = "Expands 'hsw' into '\\hswitch{}{<>}'",
  --   },
  --   fmta(
  --     [[
  --     \hsw{
  --       <>
  --     }
  --     <>
  --     ]],
  --     {
  --       d(1, get_visual),
  --       i(0),
  --     }
  --   )
  -- ),
  -- switch white
  s(
    {
      trig = "wsw",
      snippetType = "autosnippet",
      dscr = "Expands 'wsw' into '\\wsw{<>}'",
    },
    fmta(
      [[
      \wsw{
        <>
      }
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- switch gray
  s({
    trig = "psw",
    snippetType = "autosnippet",
    dscr = "Expands 'psw' into '\\psw{<>}'",
  }, {
    c(1, {
      fmta(
        [[
      \psw{%
        <>
      }%
      <>
      ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \psw[<>]{%
        <>
      }%
      <>
      ]],
        {
          c(1, {
            t("mypurple"),
            t("myblue"),
            t("mygreen"),
            t("myorange"),
            t("myred"),
            t("orchid"),
            t("cornflowerblue"),
            t("limegreen"),
            t("orange"),
            t("firebrick"),
          }),
          d(2, get_visual),
          i(0),
        }
      ),
    }),
  }),
  s({
    trig = "Psw",
    snippetType = "autosnippet",
    dscr = "Expands 'Psw' into '\\psw{<>}'",
  }, {
    c(1, {
      fmta(
        [[
      \psw{<>}
      ]],
        {
          d(1, get_visual),
        }
      ),
      fmta(
        [[
      \psw[<>]{<>}
      ]],
        {
          c(1, {
            t("mypurple"),
            t("myblue"),
            t("mygreen"),
            t("myorange"),
            t("myred"),
            t("orchid"),
            t("cornflowerblue"),
            t("limegreen"),
            t("orange"),
            t("firebrick"),
          }),
          d(2, get_visual),
        }
      ),
    }),
  }),
  -- choose color
  s(
    {
      trig = "ccl",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'cc' into '\\blk{<>}'",
    },
    fmta(
      [[
      \<>{<>}<>
      ]],
      {
        c(1, {
          i(1, "blk"),
          i(2, "orc"),
          i(3, "cbl"),
          i(4, "blu"),
          i(5, "gre"),
          i(6, "fgr"),
          i(7, "ora"),
          i(8, "red"),
          i(9, "myp"),
          i(10, "myb"),
          i(11, "myg"),
          i(12, "myo"),
          i(13, "myr"),
        }),
        d(2, get_visual),
        i(0),
      }
    )
  ),
  -- force white
  s(
    {
      trig = "wht",
      snippetType = "autosnippet",
      dscr = "Expands 'wht' into '\\wht{}{<>}'",
    },
    fmta(
      [[
      \wht{<>}
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- leftcenters & co
  s(
    {
      trig = "lfc",
      snippetType = "autosnippet",
      dscr = "Expands 'lfc' into '\\leftcenters{<>}{<>}'",
      condition = line_begin,
    },
    fmta(
      [[
      \leftcenters{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "lcr",
      snippetType = "autosnippet",
      dscr = "Expands 'lcr' into '\\leftcentersright{<>}{<>}{<>}'",
      condition = line_begin,
    },
    fmta(
      [[
      \leftcentersright{%
        <>
      }{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "ctr",
      snippetType = "autosnippet",
      dscr = "Expands 'ctr' into '\\centersright{<>}{<>}'",
      condition = line_begin,
    },
    fmta(
      [[
      \centersright{%
        <>
      }{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(2),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "cts",
      snippetType = "autosnippet",
      dscr = "Expands 'cts' into '\\centers{<>}{<>}'",
      condition = line_begin,
    },
    fmta(
      [[
      \centers{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- enonce
  s(
    {
      trig = "ennc",
      snippetType = "autosnippet",
      dscr = "Expands 'ennc' into '\\ennc{<>}'",
      condtion = line_begin,
    },
    fmta(
      [[
      \enonce{%
        <>
      }%
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- -- power minus one
  -- s(
  --   {
  --     trig = "([^\\])mma",
  --     regTrig = true,
  --     wordTrig = false,
  --     snippetType = "autosnippet",
  --     dscr = "Power -1",
  --     condition = tex_utils.in_mathzone,
  --   },
  --   fmta([[<>^{-<>}]], {
  --     f(function(_, snip)
  --       return snip.captures[1]
  --     end),
  --     i(1, "1"),
  --   })
  -- ),
  -- mathrm
  s({
    trig = "trm",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta("\\mathrm{<>}", { d(1, get_visual) })),
  s({
    trig = "rm",
    wordTrig = true,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta("\\rm <>", { d(1, get_visual) })),
  -- mathcal
  s({
    trig = "mtc",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta("\\mathcal{<>}", { d(1, get_visual) })),
  s(
    {
      trig = "([%a])cal",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\<>c", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  -----------------------------------------------------------------------------
  -- Shorthands
  -----------------------------------------------------------------------------
  -- greek
  s({
    trig = "@a",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\alpha"),
  }),
  s({
    trig = "@b",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\beta"),
  }),
  s({
    trig = "@g",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\gamma"),
  }),
  s({
    trig = "@G",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\Gamma"),
  }),
  s({
    trig = "@l",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\lambda"),
  }),
  s({
    trig = "@w",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\w"),
  }),
  s({
    trig = "@W",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\W"),
  }),
  s({
    trig = "@O",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\Omega"),
  }),
  s({
    trig = "@t",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\th"),
  }),
  s({
    trig = "@p",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\pi"),
  }),
  s({
    trig = "@m",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\mu"),
  }),
  s({
    trig = "@d",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta(
    "\\delta<>",
    { c(1, { fmta("{<>}", { d(1, get_visual) }), t("") }) }
  )),
  s({
    trig = "@D",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta(
    "\\Delta<>",
    { c(1, { fmta("{<>}", { d(1, get_visual) }), t("") }) }
  )),
  -- sigma
  s({
    trig = "@s",
    snippetType = "autosnippet",
    dscr = "Expands '@s' into '\\sigma'",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\sigma"),
  }),
  s({
    trig = "@f",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\phi"),
  }),
  s({
    trig = "@F",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\Phi"),
  }),
  -- infinity
  s({
    trig = "@8",
    -- wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\infty"),
  }),
  -- parenthesis
  -- s({
  --   trig = "pp",
  --   wordTrig = false,
  --   snippetType = "autosnippet",
  --   condition = tex_utils.in_mathzone,
  -- }, fmta("(<>)", { d(1, get_visual) })),
  s({
    trig = "pp",
    snippetType = "autosnippet",
  }, {
    c(1, {
      fmta("(<>)", { d(1, get_visual) }),
      fmta("[<>]", { d(1, get_visual) }),
      fmta("{<>}", { d(1, get_visual) }),
    }),
  }),
  s({
    trig = "pc",
    snippetType = "autosnippet",
  }, fmta("[<>]", { d(1, get_visual) })),
  -- bullet
  s({
    trig = "blt",
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\bullet"),
  }),
  -- in math text and spaces
  s({
    trig = "qud",
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\quad "),
  }),
  s({
    trig = "qqud",
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\qquad "),
  }),
  s(
    {
      trig = "(q)([easodcrl])([tnvoucra])",
      regTrig = true,
      snippetType = "autosnippet",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\<><><>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
    })
  ),
  s(
    {
      trig = "(qq)([easodcrl])([tnvoucra])",
      regTrig = true,
      snippetType = "autosnippet",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\<><><>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
    })
  ),
  s(
    {
      trig = "qmt",
      snippetType = "autosnippet",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\qMath{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "qqmt",
      snippetType = "autosnippet",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\qqMath{<>}]], {
      d(1, get_visual),
    })
  ),
  -- notations points
  -- s({
  --   trig = "rpt",
  --   snippetType = "autosnippet",
  -- }, fmta("\\hfill \\textcolor{red}{/<>}", { d(1, get_visual) })),
  -- s({
  --   trig = "gpt",
  --   snippetType = "autosnippet",
  -- }, fmta("\\hfill \\textcolor{ForestGreen}{/<>}", { d(1, get_visual) })),
  -----------------------------------------------------------------------------
  -- maths
  -----------------------------------------------------------------------------
  -- equal and stuff
  s({
    trig = "tms",
    snippetType = "autosnippet",
    dscr = "times",
    condition = tex_utils.in_mathzone,
  }, { t("\\times ") }),
  s({
    trig = "<= ",
    snippetType = "autosnippet",
    dscr = "leq",
    condition = tex_utils.in_mathzone,
  }, { t("\\leq ") }),
  s({
    trig = ">=",
    snippetType = "autosnippet",
    dscr = "geq",
    condition = tex_utils.in_mathzone,
  }, { t("\\geq ") }),
  s({
    trig = "±",
    snippetType = "autosnippet",
    dscr = "plus or minus",
    condition = tex_utils.in_mathzone,
  }, { t("\\pm ") }),
  s({
    trig = "neq",
    snippetType = "autosnippet",
    dscr = "neq",
    condition = tex_utils.in_mathzone,
  }, { t("\\neq ") }),
  s({
    trig = "≠",
    snippetType = "autosnippet",
    dscr = "neq",
    condition = tex_utils.in_mathzone,
  }, { t("\\neq ") }),
  s({
    trig = "apr",
    snippetType = "autosnippet",
    dscr = "approx",
    condition = tex_utils.in_mathzone,
  }, { t("\\approx ") }),
  s({
    trig = "~~",
    snippetType = "autosnippet",
    dscr = "sim",
    condition = tex_utils.in_mathzone,
  }, { t("\\sim ") }),
  s({
    trig = ">~",
    snippetType = "autosnippet",
    dscr = "gsim",
    condition = tex_utils.in_mathzone,
  }, { t("\\gtrsim ") }),
  s({
    trig = "<~",
    snippetType = "autosnippet",
    dscr = "gsim",
    condition = tex_utils.in_mathzone,
  }, { t("\\lesssim ") }),
  s({
    trig = ">>",
    snippetType = "autosnippet",
    dscr = "gg",
    condition = tex_utils.in_mathzone,
  }, { t("\\gg ") }),
  s({
    trig = "<<",
    snippetType = "autosnippet",
    dscr = "ll",
    condition = tex_utils.in_mathzone,
  }, { t("\\ll ") }),
  s({
    trig = "cdt",
    snippetType = "autosnippet",
    dscr = "cdot",
    condition = tex_utils.in_mathzone,
  }, { t("\\cdot ") }),
  s({
    trig = "odt",
    snippetType = "autosnippet",
    dscr = "odot",
    condition = tex_utils.in_mathzone,
  }, { t("\\odot ") }),
  s({
    trig = "ots",
    snippetType = "autosnippet",
    dscr = "ots",
    condition = tex_utils.in_mathzone,
  }, { t("\\otimes ") }),
  s({
    trig = "wdg",
    snippetType = "autosnippet",
    dscr = "wedge",
    condition = tex_utils.in_mathzone,
  }, { t("\\wedge ") }),
  s({
    trig = "inn",
    snippetType = "autosnippet",
    dscr = "in",
    condition = tex_utils.in_mathzone,
  }, { t("\\in ") }),
  s({
    trig = "prr",
    snippetType = "autosnippet",
    dscr = "parralel",
    condition = tex_utils.in_mathzone,
  }, { t("\\parr ") }),
  s({
    trig = "prp",
    snippetType = "autosnippet",
    dscr = "perpendicular",
    condition = tex_utils.in_mathzone,
  }, { t("\\perp ") }),
  -- arrows
  s({
    trig = "ra ",
    snippetType = "autosnippet",
    dscr = "rightarrow",
    condition = tex_utils.in_mathzone,
  }, { t("\\ra ") }),
  s({
    trig = "Ra",
    snippetType = "autosnippet",
    dscr = "Rightarrow",
    condition = tex_utils.in_mathzone,
  }, { t("\\Ra ") }),
  s({
    trig = "Lra",
    snippetType = "autosnippet",
    dscr = "Rightarrow",
    condition = tex_utils.in_mathzone,
  }, { t("\\Lra") }),
  s({
    trig = "opto",
    snippetType = "autosnippet",
    dscr = "opto",
    condition = tex_utils.in_mathzone,
  }, fmta("\\opto{<>}{<>}", { i(1, "above"), i(2, "below") })),
  -- shorthands
  s({
    trig = "^^",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Superscript",
    condition = tex_utils.in_mathzone,
  }, fmta("^{<>}", { d(1, get_visual) })),
  s({
    trig = "^^",
    dscr = "Superscript",
    condition = tex_utils.in_mathzone,
  }, fmta("^{<>}", { d(1, get_visual) })),
  s(
    {
      trig = "([^\\])mma",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Power -1",
      condition = tex_utils.in_mathzone,
    },
    fmta([[<>^{-<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, "1"),
    })
  ),
  s({
    trig = "__",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Subscript",
    condition = tex_utils.in_mathzone,
  }, fmta("_{<>}", { d(1, get_visual) })),
  s({
    trig = "_",
    dscr = "Subscript",
    condition = tex_utils.in_mathzone,
  }, fmta("_{<>}", { d(1, get_visual) })),
  -- subtext
  s({
    trig = "ind",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Subtext",
    condition = tex_utils.in_mathzone,
  }, fmta("\\ind{<>}", { d(1, get_visual) })),
  -- suptext
  s({
    trig = "sup",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Suptext",
    condition = tex_utils.in_mathzone,
  }, fmta("\\sup{<>}", { d(1, get_visual) })),
  -- sub super scripts
  s(
    {
      trig = "([a-df-zA-Z])(%d)",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Auto subscript 1 digit",
      condition = tex_utils.in_mathzone,
    },
    fmta([[<>_<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  s(
    {
      trig = "(%a)_(%d%d)",
      regTrig = true,
      snippetType = "autosnippet",
      dscr = "Auto subscript 2+ digits",
      condition = tex_utils.in_mathzone,
    },
    fmta([[<>_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  -- sub rm
  s({
    trig = "srm",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\rm <>}", { d(1, get_visual) })),
  s({
    trig = "Srm",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\mathrm{<>}}", { d(1, get_visual) })),
  -- s({
  --   trig = "ext",
  --   wordTrig = false,
  --   snippetType = "autosnippet",
  --   condition = tex_utils.in_mathzone,
  -- }, {
  --   t("\\ext"),
  -- }),
  s({
    trig = "sex",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\ind{exp}"),
  }),
  s({
    trig = "seq",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\ind{eq}"),
  }),
  -- fraction
  s({
    trig = "ff",
    snippetType = "autosnippet",
    dscr = "Expands 'ff' into '\frac{}{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\frac{<>}{<>}", { d(1, get_visual), i(2) })),
  -- s({
  --   trig = "ff",
  --   dscr = "Expands 'ff' into '\frac{}{}'",
  -- }, fmta("\\frac{<>}{<>}", { i(1), i(2) })),
  -- left right
  s({
    trig = "ll",
    snippetType = "autosnippet",
    dscr = "Expands 'll' into '\\left( \right)'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\left( <> \\right)", (d(1, get_visual))),
      fmta("\\left[ <> \\right]", (d(1, get_visual))),
      fmta("\\left\\{ <> \\right.", (d(1, get_visual))),
    }),
  }),
  -- left fraction right
  s({
    trig = "lf",
    snippetType = "autosnippet",
    dscr = "Expands 'lf' into '\\left( \frac{}{} \right)'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta(
        "\\left( \\frac{<>}{<>}<> \\right)",
        { d(1, get_visual), i(2), i(3) }
      ),
      fmta(
        "\\left[ \\frac{<>}{<>}<> \\right]",
        { d(1, get_visual), i(2), i(3) }
      ),
      fmta(
        "\\left\\{ \\frac{<>}{<>}<> \\right\\}",
        { d(1, get_visual), i(2), i(3) }
      ),
    }),
  }),
  -- par
  s({
    trig = "par",
    snippetType = "autosnippet",
    dscr = "Expands 'par' into '\\pa{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\pa{<>}", { d(1, get_visual) })),
  -- ()
  -- s({
  --   trig = "(",
  --   snippetType = "autosnippet",
  --   wordTrig = false,
  -- }, fmta("(<>)<>", { d(1, get_visual), i(0) })),
  -- pac
  s({
    trig = "pac",
    snippetType = "autosnippet",
    dscr = "Expands 'pac' into '\\pac{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\pac{<>}", { d(1, get_visual) })),
  -- paa
  s({
    trig = "paa",
    snippetType = "autosnippet",
    dscr = "Expands 'paa' into '\\paa{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\paa{<>}", { d(1, get_visual) })),
  -- ln, log, exp & co
  s({
    trig = "ln",
    snippetType = "autosnippet",
    dscr = "Expands 'ln' into '\\ln'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\ln <>", { d(1, get_visual) })),
  s({
    trig = "lg",
    snippetType = "autosnippet",
    dscr = "Expands 'lg' into '\\log'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\log <>", { d(1, get_visual) })),
  s(
    {
      trig = "xp",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'xp' into '\\exp'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\exp<>", {
      c(1, {
        fmta("<>", { d(1, get_visual) }),
        fmta("(<>)", { d(1, get_visual) }),
      }),
    })
  ),
  s({
    trig = "xx",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'xx' into 'e^{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\exr^{<>}", { d(1, get_visual) })),
  s({
    trig = "jj",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jj' into '\\jj'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jj ") }),
  s({
    trig = "jw",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jw' into '\\jw'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jw") }),
  s({
    trig = "jcw",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jcw' into '\\jcw'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jcw") }),
  s({
    trig = "jrcw",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jrcw' into '\\jrcw'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jrcw") }),
  s({
    trig = "jlw",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jlw' into '\\jlw'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jlw") }),
  s({
    trig = "jx",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'jx' into '\\jx'",
    condition = tex_utils.in_mathzone,
  }, { t("\\jx") }),
  -- trigfuncs
  s({
    trig = "cos",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'cos' into '\\cos{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\cos(<>)", { i(1, "\\th") }),
      fmta("\\cos{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "arcc",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'acos' into '\\acos{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\arccos(<>)", { i(1, "\\th") }),
      fmta("\\arccos{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "sin",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'sin' into '\\sin{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\sin(<>)", { i(1, "\\th") }),
      fmta("\\sin{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "arcs",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'asin' into '\\asin{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\arcsin(<>)", { i(1, "\\th") }),
      fmta("\\arcsin{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "tan",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'tan' into '\\tan{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\tan(<>)", { i(1, "\\th") }),
      fmta("\\tan{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "arct",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'atan' into '\\atan{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\arctan(<>)", { i(1, "\\th") }),
      fmta("\\arctan{<>}", { i(1, "\\th") }),
    }),
  }),
  s({
    trig = "arg",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'arg' into '\\arg{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\arg*{<>}", { i(1, "\\th") }),
      fmta("\\arg{<>}", { i(1, "\\th") }),
    }),
  }),
  -- integrals
  s(
    {
      trig = "int",
      snippetType = "autosnippet",
      wordTrig = true,
      dscr = "Expands 'int' into '\\int'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\int<>", {
      c(1, {
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        t(" "),
      }),
    })
  ),
  s(
    {
      trig = "oint",
      snippetType = "autosnippet",
      dscr = "Expands 'oint' into '\\oint'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\oint<>", {
      c(1, {
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        t(" "),
      }),
    })
  ),
  s(
    {
      trig = "iint",
      snippetType = "autosnippet",
      dscr = "Expands 'iint' into '\\iint'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\iint<>", {
      c(1, {
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        t(" "),
      }),
    })
  ),
  s(
    {
      trig = "oiint",
      snippetType = "autosnippet",
      dscr = "Expands 'oiint' into '\\oiint'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\oiint<>", {
      c(1, {
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        t(" "),
      }),
    })
  ),
  s(
    {
      trig = "iiint",
      snippetType = "autosnippet",
      dscr = "Expands 'iiint' into '\\iiint'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\iiint<>", {
      c(1, {
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        t(" "),
      }),
    })
  ),
  s(
    {
      trig = "oiiint",
      snippetType = "autosnippet",
      dscr = "Expands 'oiiint' into '\\oiiint'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\oiiint<>", {
      c(1, {
        fmta([[_{<>}]], {
          i(1, "lower"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        t(" "),
      }),
    })
  ),
  -- sum
  s(
    {
      trig = "sum",
      snippetType = "autosnippet",
      dscr = "Expands 'sum' into '\\sum'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\sum<>", {
      c(1, {
        t(" "),
        fmta([[_{<>}]], {
          i(1, "i"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "n=1"),
          i(2, "+\\infty"),
        }),
      }),
    })
  ),
  -- prod
  s(
    {
      trig = "prod",
      snippetType = "autosnippet",
      dscr = "Expands 'prod' into '\\prod'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\prod<>", {
      c(1, {
        t(" "),
        fmta([[_{<>}]], {
          i(1, "i"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "lower"),
          i(2, "upper"),
        }),
        fmta([[_{<>}^{<>}]], {
          i(1, "n=1"),
          i(2, "+\\infty"),
        }),
      }),
    })
  ),
  -- Sim
  s(
    {
      trig = "sim",
      snippetType = "autosnippet",
      dscr = "Expands 'sim' into '\\Sim'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\Sim_{<>}", {
      i(1, "x \\to 0"),
    })
  ),
  -- straight derive
  s(
    {
      trig = "dv",
      snippetType = "autosnippet",
      dscr = "Expands 'dv' into '\\dv'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\dv{<>}<>", {
      d(1, get_visual),
      c(2, {
        fmta("{<>}", { i(1) }),
        t(""),
      }),
    })
  ),
  s(
    {
      trig = "db",
      snippetType = "autosnippet",
      dscr = "Expands 'db' into '\\dv[]'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\dv[<>]{<>}<>", {
      i(1),
      i(2),
      c(3, {
        fmta("{<>}", { i(1) }),
        t(""),
      }),
    })
  ),
  -- partial derive
  s({
    trig = "pdv",
    snippetType = "autosnippet",
    dscr = "Expands 'pdv' into '\\pdv'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\pdv{<>}{<>}", { i(1), i(2) })),
  s({
    trig = "pdb",
    snippetType = "autosnippet",
    dscr = "Expands 'pdv' into '\\pdv'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\pdv[<>]{<>}{<>}", { i(1), i(2), i(3) })),
  -- eval
  s(
    {
      trig = "evl",
      snippetType = "autosnippet",
      dscr = "Expands 'evl' into '\\eval'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\eval{<>}_{<>}", {
      d(1, get_visual),
      i(2),
    })
  ),
  -- qty
  s({
    trig = "qty",
    snippetType = "autosnippet",
    dscr = "Expands 'qty' into '\\qty'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\qty(<>)", { d(1, get_visual) }),
      fmta("\\qty{<>}", { d(1, get_visual) }),
    }),
  }),
  --
  -- fmta("\\qty{<>}", {
  --   d(1, get_visual),
  -- })
  -- ),
  -- mqty
  s({
    trig = "mqty",
    snippetType = "autosnippet",
    dscr = "Expands 'mqty' into '\\mqty'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\mqty(<>)", { d(1, get_visual) }),
      fmta("\\mqty{<>}", { d(1, get_visual) }),
    }),
  }),
  -- differential
  s({
    trig = "dd",
    snippetType = "autosnippet",
    dscr = "Expands 'dd' into '\\dd{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\dd{<>}", { d(1, get_visual) })),
  s(
    {
      trig = "(d)([trxyz])",
      regTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'dx' into '\\dx'",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\d<>]], {
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  -- cancels
  s({
    trig = "cl",
    snippetType = "autosnippet",
    dscr = "Expands 'cl' into '\\cancel{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\cancel{<>}", { d(1, get_visual) })),
  s({
    trig = "bcl",
    snippetType = "autosnippet",
    dscr = "Expands 'bcl' into '\\bcancel{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\bcancel{<>}", { d(1, get_visual) })),
  s({
    trig = "dcl",
    snippetType = "autosnippet",
    dscr = "Expands 'dcl' into '\\dcancel{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\dcancel{<>}", { d(1, get_visual) })),
  -- delta
  s({
    trig = "del",
    snippetType = "autosnippet",
    dscr = "Expands 'de' into '\\de{}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\de{<>}", { d(1, get_visual) })),
  -- ell
  s({
    trig = "ell",
    snippetType = "autosnippet",
    dscr = "Expands 'ell' into '\\ell'",
    condition = tex_utils.in_mathzone,
  }, { t("\\ell") }),
  -- abs val root
  s({
    trig = "abs",
    snippetType = "autosnippet",
    dscr = "Expands 'abs' into '\\abs'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\abs{<>}", { d(1, get_visual) })),
  s({
    trig = "abs",
    dscr = "Expands 'abs' into '\\abs'",
  }, fmta("\\abs{<>}", { d(1, get_visual) })),
  -- lim min max
  s({
    trig = "lim",
    wordTrig = false,
    snippetType = "autosnippet",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, { fmta("\\lim_{<>}", { i(1) }), t("\\lim") }),
  }),
  -- s({
  --   trig = "min",
  --   wordTrig = false,
  --   snippetType = "autosnippet",
  --   condition = tex_utils.in_mathzone,
  -- }, {
  --   c(1, { t("\\min"), fmta("\\min_{<>}", { i(1) }) }),
  -- }),
  -- s({
  --   trig = "max",
  --   wordTrig = false,
  --   snippetType = "autosnippet",
  --   condition = tex_utils.in_mathzone,
  -- }, {
  --   c(1, { t("\\max"), fmta("\\max_{<>}", { i(1) }) }),
  -- }),
  -- norm
  s({
    trig = "nrm",
    snippetType = "autosnippet",
    dscr = "Expands 'nrm' into '\\norm'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\norm{<>}", { d(1, get_visual) })),
  -- mean
  s({
    trig = "moy",
    snippetType = "autosnippet",
    dscr = "Expands 'moy' into '\\moy'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\moy{<>}", { d(1, get_visual) })),
  -- square root
  s({
    trig = "sqr",
    snippetType = "autosnippet",
    dscr = "Expands 'sqr' into '\\sqrt'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\sqrt{<>}", { d(1, get_visual) })),
  s({
    trig = "sqf",
    snippetType = "autosnippet",
    dscr = "Expands 'sqf' into '\\sqrt{\frac}'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\sqrt{\\frac{<>}{<>}}", { i(1), i(2) })),
  -- vectors
  -- s(
  --   {
  --     trig = "V(\\*%a)",
  --     regTrig = true,
  --     snippetType = "autosnippet",
  --     dscr = "Expands 'V<letter>' into '\\vv{<letter>}'",
  --     condition = tex_utils.in_mathzone,
  --   },
  --   fmta("\\vv{<><>}", {
  --     f(function(_, snip)
  --       return snip.captures[1]
  --     end),
  --     i(1),
  --   })
  -- ),
  s({
    trig = "vv",
    regTrig = true,
    snippetType = "autosnippet",
    dscr = "Expands 'vv' into '\\vv{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\vv{<>}", {
        d(1, get_visual),
      }),
      fmta("\\vvr{<>}", {
        d(1, get_visual),
      }),
    }),
  }),
  s(
    {
      trig = "([^\\^q])([eu])([xyzrtdf]) ",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Makes base vectors (x,y,z,r,t,f)",
      condition = tex_utils.in_mathzone,
    },
    fmta("<>\\<><>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
    })
  ),
  -- chemical formula
  s({
    trig = "cce",
    snippetType = "autosnippet",
    dscr = "Expands 'cce' into '\\ce'",
  }, fmta("\\ce{<>}", { d(1, get_visual) })),
  s({
    trig = "cfg",
    snippetType = "autosnippet",
    dscr = "Expands 'cfig' into '\\cfig'",
  }, fmta("\\cfig{<>}", { d(1, get_visual) })),
  s({
    trig = "chg",
    snippetType = "autosnippet",
    dscr = "Expands 'chg' into '\\charge'",
  }, fmta("\\charge{<>}{<>}", { i(1), d(2, get_visual) })),
  s(
    {
      trig = "chb",
      snippetType = "autosnippet",
      dscr = "Expands 'chb' into '\\chemabove'",
    },
    fmta("\\chemabove{<>}{\\hspace{<>}<>}", {
      d(1, get_visual),
      i(2, "0.5cm"),
      c(3, { i(1, "\\ominus"), i(2, "\\oplus") }),
    })
  ),
  s({
    trig = "nno",
    snippetType = "autosnippet",
    dscr = "Expands 'nno' into '\\no'",
  }, {
    c(1, {
      fmta("\\no{<>}", { d(1, get_visual) }),
      fmta("\\no <>", { i(0) }),
    }),
  }),
  s({
    trig = "Rmn",
    snippetType = "autosnippet",
    dscr = "Expands 'Rmn' into '\\Roman'",
  }, fmta("\\myRoman{<>}", { d(1, get_visual) })),
  -- état physique
  s({
    trig = "aqu",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'aqu' into '_{\\rm (aq)}'",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\aqu}<>", { i(0) })),
  s({
    trig = "liq",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'liq' into '_{\\rm (liq)}'",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\liq}<>", { i(0) })),
  s({
    trig = "gaz",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'gaz' into '_{\\rm (gaz)}'",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\gaz}<>", { i(0) })),
  s({
    trig = "sol",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'sol' into '_{\\rm (sol)}'",
    condition = tex_utils.in_mathzone,
  }, fmta("_{\\sol}<>", { i(0) })),
  s({
    trig = "eql",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'eql' into '\\eql'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\eql<>", { i(0) })),
  s({
    trig = "pH",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'pH' into '\\pH'",
    condition = tex_utils.in_mathzone,
  }, { t("\\pH") }),
  s({
    trig = "pK",
    snippetType = "autosnippet",
    wordTrig = false,
    dscr = "Expands 'pK' into '\\pK[]'",
    condition = tex_utils.in_mathzone,
  }, fmta("\\pk<>", { c(1, { t(""), fmta("[<>]", { i(1) }) }) })),
  -- tabav
  s(
    {
      trig = "tbv",
      snippetType = "autosnippet",
      dscr = "Expands 'tbv' into a tableau d'avancement",
      condition = line_begin,
    },
    fmta(
      [[
    \begin{center}
	      \def\rhgt{<>}
        \centering
	      \begin{tabularx}{\linewidth}{|l|c|YdYdYdY|}
	      	\hline
	      	\multicolumn{2}{|c|}{
	      		$\xmathstrut{\rhgt}$
	      	\textbf{Équation}}       &
	      	$<>\ce{<>}$              & $+$                 &
	      	$<>\ce{<>}$              & $\ra$               &
	      	$<>\ce{<>}$              & $+$                 &
	      	$<>\ce{<>}$                                    \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	\textit{État}            & \textit{Avance\mnt} &
	      	$n(\ce{<>})$             & \vline              &
	      	$n(\ce{<>})$             & \vline              &
	      	$n(\ce{<>})$             & \vline              &
	      	$n(\ce{<>})$                                   \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Initial                  & $<> = 0$           &
	      	$n_0(\ce{<>})$           & \vline              &
	      	$n_0(\ce{<>})$           & \vline              &
	      	$n_0(\ce{<>})$           & \vline              &
	      	$n_0(\ce{<>})$                                 \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Interm.                  & $<>$               &
	      	$n_0(\ce{<>}) - <><>$   & \vline              &
	      	$n_0(\ce{<>}) - <><>$   & \vline              &
	      	$n_0(\ce{<>}) + <><>$   & \vline              &
	      	$n_0(\ce{<>}) + <><>$                         \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Final                    & $<> = <>_f$             &
	      	$n_0(\ce{<>}) - <><>_f$ & \vline              &
	      	$n_0(\ce{<>}) - <><>_f$ & \vline              &
	      	$n_0(\ce{<>}) + <><>_f$ & \vline              &
	      	$n_0(\ce{<>}) + <><>_f$                       \\
	      	\hline
	      \end{tabularx}
    \end{center}
    <>
      ]],
      {
        i(1, "0.35"),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        rep(3),
        rep(5),
        rep(7),
        rep(9),
        i(14, "\\xi"),
        rep(3),
        rep(5),
        rep(7),
        rep(9),
        rep(14),
        rep(3),
        rep(2),
        rep(14),
        rep(5),
        rep(4),
        rep(14),
        rep(7),
        rep(6),
        rep(14),
        rep(9),
        rep(8),
        rep(14),
        rep(14),
        rep(14),
        rep(3),
        rep(2),
        rep(14),
        rep(5),
        rep(4),
        rep(14),
        rep(7),
        rep(6),
        rep(14),
        rep(9),
        rep(8),
        rep(14),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "tabv",
      snippetType = "autosnippet",
      dscr = "Expands 'tabv' into a tableau d'avancement numérique",
      condition = line_begin,
    },
    fmta(
      [[
    \begin{center}
	      \def\rhgt{<>}
        \centering
	      \begin{tabularx}{\linewidth}{|l|c||YdYdYdY|}
	      	\hline
	      	\multicolumn{2}{|c||}{
	      		$\xmathstrut{\rhgt}$
	      	\textbf{Équation}} &
	      	$<>\ce{<>}$        & $+$                 &
	      	$<>\ce{<>}$        & $\ra$               &
	      	$<>\ce{<>}$        & $+$                 &
	      	$<>\ce{<>}$                              \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Initial            & $<> = 0$           &
	      	$<>$               & \vline              &
	      	$<>$               & \vline              &
	      	$<>$               & \vline              &
	      	$<>$                                     \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Interm.            & $<>$               &
	      	$<> - <><>$       & \vline              &
	      	$<> - <><>$       & \vline              &
	      	$<> + <><>$       & \vline              &
	      	$<> + <><>$                             \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Final              & $<>_f = <>_{<>}$         &
	      	$<> - <><>_{<>}$     & \vline              &
	      	$<> - <><>_{<>}$     & \vline              &
	      	$<> + <><>_{<>}$     & \vline              &
	      	$<> + <><>_{<>}$                           \\
	      	\hline
	      \end{tabularx}
    \end{center}
    <>
      ]],
      {
        i(1, "0.50"),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10, "\\xi"),
        i(11),
        i(12),
        i(13),
        i(14),
        rep(10),
        rep(11),
        rep(2),
        rep(10),
        rep(12),
        rep(4),
        rep(10),
        rep(13),
        rep(6),
        rep(10),
        rep(14),
        rep(8),
        rep(10),
        rep(10),
        rep(10),
        i(30, "\\equ"),
        -- c(30, { t("\\equ"), t("\\max") }),
        rep(11),
        rep(2),
        rep(10),
        rep(30),
        rep(12),
        rep(4),
        rep(10),
        rep(30),
        rep(13),
        rep(6),
        rep(10),
        rep(30),
        rep(14),
        rep(8),
        rep(10),
        rep(30),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "tabg",
      snippetType = "autosnippet",
      dscr = "Expands 'tabg' into a tableau d'avancement numérique avec gaz",
      condition = line_begin,
    },
    fmta(
      [[
    \begin{center}
	      \def\rhgt{<>}
        \centering
	      \begin{tabularx}{\linewidth}{|l|c||YdYdYdY||Y|}
	      	\hline
	      	\multicolumn{2}{|c||}{
	      		$\xmathstrut{\rhgt}$
	      	\textbf{Équation}} &
	      	$<>\ce{<>}$        & $+$                 &
	      	$<>\ce{<>}$        & $\ra$               &
	      	$<>\ce{<>}$        & $+$                 &
	      	$<>\ce{<>}$        &
	      	$n_{\tot, gaz}$                          \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Initial            & $<> = 0$            &
	      	$<>$               & \vline              &
	      	$<>$               & \vline              &
	      	$<>$               & \vline              &
	      	$<>$               &
          $<>$                                    \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Interm.            & $<>$               &
	      	$<> - <><>$       & \vline              &
	      	$<> - <><>$       & \vline              &
	      	$<> + <><>$       & \vline              &
	      	$<> + <><>$       &
	      	$<> + <><>$                             \\
	      	\hline
	      	$\xmathstrut{\rhgt}$
	      	Final              & $<> = <>_f$        &
	      	$<> - <><>_f$     & \vline              &
	      	$<> - <><>_f$     & \vline              &
	      	$<> + <><>_f$     & \vline              &
	      	$<> + <><>_f$     &
          $<> + <><>_f$                           \\
	      	\hline
	      \end{tabularx}
    \end{center}
    <>
      ]],
      {
        i(1, "0.50"),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10, "\\xi"),
        i(11),
        i(12),
        i(13),
        i(14),
        i(15),
        rep(10),
        rep(11),
        rep(2),
        rep(10),
        rep(12),
        rep(4),
        rep(10),
        rep(13),
        rep(6),
        rep(10),
        rep(14),
        rep(8),
        rep(10),
        rep(15),
        i(29),
        i(10),
        rep(10),
        rep(10),
        rep(11),
        rep(2),
        rep(10),
        rep(12),
        rep(4),
        rep(10),
        rep(13),
        rep(6),
        rep(10),
        rep(14),
        rep(8),
        rep(10),
        rep(15),
        rep(29),
        rep(10),
        i(0),
      }
    )
  ),
  -- SIunit
  -- s(
  --   {
  --     trig = "(%s)SI",
  --     regTrig = true,
  --     wordTrig = false,
  --     snippetType = "autosnippet",
  --     dscr = "Expands 'SI' into '\\SI{}{}'",
  --   },
  --   fmta("<>\\SI{<>}{<>}", {
  --     f(function(_, snip)
  --       return snip.captures[1]
  --     end),
  --     i(1, "value"),
  --     i(2, "unit"),
  --   })
  -- ),
  s({
    trig = "SI",
    snippetType = "autosnippet",
    dscr = "Expands 'SI' into '\\SI{}{}'",
  }, {
    c(1, {
      fmta("\\SI{<>}{<>}", {
        d(1, get_visual),
        i(2, "unit"),
      }),
      fmta("\\SIrange{<>}{<>}{<>}", {
        i(1, "lower"),
        i(2, "upper"),
        i(3, "unit"),
      }),
    }),
  }),
  -- units
  s(
    {
      trig = "sii",
      snippetType = "autosnippet",
      dscr = "Expands 'sii' into '\\si{}'",
    },
    fmta("\\si{<>}", {
      d(1, get_visual),
    })
  ),
  -- angles
  s(
    {
      trig = "ang",
      snippetType = "autosnippet",
      dscr = "Expands 'ang' into '\\ang{}'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\ang{<>}", {
      d(1, get_visual),
    })
  ),
  -- celsius
  s({
    trig = "cel",
    snippetType = "autosnippet",
    dscr = "Expands 'cel' into '\\degreeCelsius'",
    condition = tex_utils.in_mathzone,
  }, { t("\\degreeCelsius") }),
  s({
    trig = "cel",
    dscr = "Expands 'cel' into '\\degreeCelsius'",
  }, { t("\\degreeCelsius") }),
  s({
    trig = "°",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands '°' into '^\\circ'",
  }, { t("^\\circ") }),
  -- num
  s(
    {
      trig = "nmm",
      snippetType = "autosnippet",
      dscr = "Expands 'nmm' into '\\num{}'",
    },
    fmta("\\num{<>}", {
      d(1, get_visual),
    })
  ),
  -- inline math
  s(
    {
      trig = "mm",
      snippetType = "autosnippet",
      dscr = "Expands 'mm' into '$ $'",
      condition = tex_utils.in_text,
    },
    fmta("$<>$", {
      d(1, get_visual),
    })
  ),
  -- display math
  s(
    {
      trig = "$$",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands '$$' into '\\[ \\]'",
    },
    fmta(
      [[
      \[
        <>
      \]
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- notag
  s({
    trig = "ntg",
    snippetType = "autosnippet",
    dscr = "Expands 'ntg' into '\\notag'",
    condition = tex_utils.in_mathzone,
  }, {
    t("\\notag"),
  }),
  -- tagform
  s(
    {
      trig = "tgf",
      snippetType = "autosnippet",
      dscr = "Expands 'tgf' into '\\usetagform'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\usetagform{<>}", {
      i(1, "black"),
    })
  ),
  -- tikzmark
  s({
    trig = "tkm",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'tkm' into '\\tikzmark{<>}'",
  }, fmta("\\tikzmark{<>}", { d(1, get_visual) })),
  -- tikz from tikzmark
  s(
    {
      trig = "Tkm",
      snippetType = "autosnippet",
      dscr = "Expands 'Tkm' into '\\tikz[remember picture, overlay]'",
    },
    fmta(
      [[
      \tikz[remember picture, overlay]
      \draw[-stealth, transform canvas={<>}]
        (pic cs:<>) to <> ([shift={<>}]pic cs:<>)
        ;
      <>
      ]],
      {
        i(1, "yshift=6pt"),
        i(2, "IN"),
        c(3, { t(""), t("[out=90, in=90]") }),
        i(4, "(-6pt,6pt)"),
        i(5, "OUT"),
        i(0),
      }
    )
  ),
  -- dots
  s(
    {
      trig = "dot",
      snippetType = "autosnippet",
      dscr = "Expands 'dot' into '\\dot{<>}'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\dot{<>}", {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "dtt",
      snippetType = "autosnippet",
      dscr = "Expands 'dtt' into '\\ddot{<>}'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\ddot{<>}", {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "([aprltvxyz])(dot)",
      regTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'xdot' into '\\xp'",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\<>p]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    {
      trig = "([aprltvxyz])(ddot)",
      regTrig = true,
      snippetType = "autosnippet",
      dscr = "Expands 'xdtt' into '\\xpp'",
      condition = tex_utils.in_mathzone,
    },
    fmta([[\<>pp]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  -- stack for bareme
  s(
    {
      trig = "stk",
      snippetType = "autosnippet",
      wordTrig = false,
      dscr = "Expands 'stk' into '\\stk{<>}'",
      condition = tex_utils.in_text,
    },
    fmta("\\stk{<>}", {
      d(1, get_visual),
    })
  ),
  s({
    trig = "stm",
    snippetType = "autosnippet",
    dscr = "Expands 'stm' into '\\stm{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\stm{<>}", {
        d(1, get_visual),
      }),
      fmta("\\stm[-1]{<>}", {
        d(1, get_visual),
      }),
      fmta("\\stm(un){<>}", {
        d(1, get_visual),
      }),
    }),
  }),
  s({
    trig = "stc",
    snippetType = "autosnippet",
    dscr = "Expands 'stc' into '\\stc{<>}'",
  }, {
    c(1, {
      fmta("\\stc{<>}{<>}", {
        d(1, get_visual),
        i(2, "above"),
      }),
      fmta("\\stc[-1]{<>}{<>}", {
        d(1, get_visual),
        i(2, "above"),
      }),
      fmta('\\stc"\\<>"{<>}{<>}', {
        i(1, "footnotesize"),
        d(2, get_visual),
        i(3, "above"),
      }),
    }),
  }),
  -- simple point
  s({
    trig = "prt",
    snippetType = "autosnippet",
    dscr = "Expands 'prt' into '\\protect{<>}'",
  }, {
    t("\\protect"),
  }),
  s({
    trig = "ptt",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'ptt' into '\\pt{<>}'",
  }, fmta("\\pt{<>}", { i(1, "1") })),
  -- litem generic but mostly for point
  s({
    trig = "ltm",
    snippetType = "autosnippet",
    dscr = "Expands 'ltm' into '\\ltm[<>]{<>}'",
  }, fmta("\\ltm[<>]{<>}", { i(1, "20"), i(2) })),
  -- align
  s({
    trig = "alg",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Expands 'alg' into align env",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
      \begin{align*}
        <>
      \end{align*}
      <>
      ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{align}
        <>
      \end{align}
      <>
      ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
    }),
  }),
  s(
    {
      trig = "phq",
      snippetType = "autosnippet",
      dscr = "Expands 'phq' into empheq env",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{empheq}[<>]{<>}
        <>
      \end{empheq}
      <>
      ]],
      {
        c(1, {
          i(1, "left=\\empheqlbrace"),
          i(2, "box=\\fbox"),
          i(3, "left=\\empheqlbrace, box=\\fbox"),
          t(""),
        }),
        i(2, "align"),
        i(3),
        i(0),
      }
    )
  ),
  -- Arrows and stuff
  s({
    trig = "dar",
    snippetType = "autosnippet",
    dscr = "Expands 'dar' into DispWithArrows",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
      \begin{DispWithArrows}[<>]
        <>
      \end{DispWithArrows}
      <>
      ]],
        {
          c(1, {
            t(""),
            fmta("format=<>", i(1, "ll")),
            fmta("fleqn, mathindent=<>", i(1, "1cm")),
            i(2, "groups"),
            fmta("code-after=<>", { i(1) }),
            fmta("name=<>", { i(1) }),
          }),
          d(2, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{DispWithArrows*}[<>]
        <>
      \end{DispWithArrows*}
      <>
      ]],
        {
          c(1, {
            t(""),
            fmta("format=<>", i(1, "ll")),
            fmta("fleqn, mathindent=<>", i(1, "1cm")),
            i(2, "groups"),
            fmta("code-after=<>", { i(1) }),
            fmta("name=<>", { i(1) }),
          }),
          d(2, get_visual),
          i(0),
        }
      ),
    }),
  }),
  s(
    {
      trig = "war",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'war' into WithArrows env",
      condition = tex_utils.in_mathzone,
    },
    fmta(
      [[
      \begin{WithArrows}[<>]
        <>
      \end{WithArrows}
      <>
      ]],
      {
        c(1, {
          t(""),
          i(1, "c"),
          i(2, "groups"),
          fmta("format=<>", i(1, "ll")),
          fmta("code-after=<>", { i(1) }),
          fmta("name=<>", { i(1) }),
        }),
        i(2),
        i(0),
      }
    )
  ),
  s({
    trig = "aro",
    snippetType = "autosnippet",
    dscr = "Expands 'aro' into '\\Arrow{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\Arrow{<>}", {
        d(1, get_visual),
      }),
      fmta("\\Arrow[<>]{<>}", {
        c(1, {
          i(1),
          fmta("tikz=<>", { i(1) }),
          fmta("jump=<>", { i(1) }),
        }),
        d(2, get_visual),
      }),
    }),
  }),
  s(
    {
      trig = "car",
      snippetType = "autosnippet",
      dscr = "Expands 'car' into '\\CArrow{<>}'",
      condition = tex_utils.in_mathzone,
    },
    fmta("\\CArrow{$<>$}", {
      d(1, get_visual),
    })
  ),
  -- array
  s(
    {
      trig = "arr",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'arr' into array env",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{array}{<>}
        <> & <>
        \\
        <> & <>
      \end{array}
      <>
      ]],
      {
        i(1, "ll"),
        i(2),
        i(3),
        i(4),
        i(5),
        i(0),
      }
    )
  ),
  -- appnum
  s(
    {
      trig = "apn",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'apn' into numerical application",
      condition = line_begin,
    },
    fmta(
      [[
      \qav
      \left\{%
      \begin{array}{rcl}
        <> & = & <>
        \\
        <> & = & <>
      \end{array}
      \right.
      \\\AN
      \ul{%
      <>
      }%
      <>
      ]],
      {
        i(1, "var1"),
        i(2, "val1"),
        i(3, "var2"),
        i(4, "val2"),
        i(5),
        i(0),
      }
    )
  ),
  -- makebox for long tags
  s(
    {
      trig = "mkb",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'mkb' into makebox of 0pt for no space",
    },
    fmta(
      [[
    \makebox[0pt][r]{<>}
    ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- phantom ul
  s(
    {
      trig = "pht",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'pht' into phantom ul application",
      condition = line_begin,
    },
    fmta(
      [[
    \AN
    \makebox[0pt][l]{$\ul{\phantom{<>}}$}
    <>
    ]],
      {
        d(1, get_visual),
        rep(1),
      }
    )
  ),
  -- reglin
  s(
    {
      trig = "reglin",
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Expands 'reglin' into linear regression",
      condition = line_begin,
    },
    fmta(
      [[
      \[
        y\tikzmark{<>} = a\tikzmark{<>}x\tikzmark{<>} + b\tikzmark{<>}
      \]
      \tikz[remember picture, overlay]
      \draw[-stealth, transform canvas={xshift=-6pt, yshift=-6pt}]
      (pic cs:<>) --++ (-10pt,-10pt)
      node[anchor=north east] {$<>$}
      ;
      \tikz[remember picture, overlay]
      \draw[-stealth, transform canvas={xshift=-5pt, yshift=-6pt}]
      (pic cs:<>) --++(-5pt,-10pt)
      node[anchor=north] {$<>$}
      ;
      \tikz[remember picture, overlay]
      \draw[-stealth, transform canvas={xshift=0pt, yshift=-6pt}]
      (pic cs:<>) --++(5pt,-10pt)
      node[anchor=north] {$<>$}
      ;
      \tikz[remember picture, overlay]
      \draw[-stealth, transform canvas={xshift=3pt, yshift=-6pt}]
      (pic cs:<>) --++(10pt,-10pt)
      node[anchor=north west] {$<>$}
      ;
      <>
      ]],
      {
        i(1, "yn"),
        i(2, "an"),
        i(3, "xn"),
        i(4, "bn"),
        rep(1),
        i(5, "Y"),
        rep(2),
        i(6, "A"),
        rep(3),
        i(7, "X"),
        rep(4),
        i(8, "B"),
        i(0),
      }
    )
  ),
  -- obar
  s({
    trig = "obr",
    snippetType = "autosnippet",
    dscr = "Expands 'obr' into '\\obr{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\obar{<>}", {
        d(1, get_visual),
      }),
      fmta("\\obarr{<>}", {
        d(1, get_visual),
      }),
    }),
  }),
  -- boxed
  s({
    trig = "bx",
    snippetType = "autosnippet",
    dscr = "Expands 'bx' into '\\boxed{<>}'",
    condition = tex_utils.in_mathzone,
  }, {
    c(1, {
      fmta("\\boxed{<>}", {
        d(1, get_visual),
      }),
      fmta("\\Aboxed{<>}", {
        d(1, get_visual),
      }),
    }),
  }),
  s(
    {
      trig = "fbx",
      snippetType = "autosnippet",
      dscr = "Expands 'fbx' into '\\fbox{<>}'",
    },
    fmta("\\fbox{<>}", {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "ftbx",
      snippetType = "autosnippet",
      dscr = "Expands 'ftbx' into '\\fatbox{<>}'",
    },
    fmta("\\fatbox{<>}", {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "rbx",
      snippetType = "autosnippet",
      dscr = "Expands 'rbx' into '\\rotatebox[<>]{<>}{<>}'",
    },
    fmta("\\rotatebox[<>]{<>}{<>}", {
      i(1, "origin=c"),
      i(2, "90"),
      d(3, get_visual),
    })
  ),
  -- underbracket & stuff
  s({
    trig = "ubk",
    snippetType = "autosnippet",
    dscr = "Expands 'ubk' into '\\underbracket{<>}_{<>}'",
  }, {
    c(1, {
      fmta("\\ub{<>}{<>}", {
        d(1, get_visual),
        i(2),
      }),
      fmta("\\xunderbracket{<>}_{<>}", {
        d(1, get_visual),
        i(2),
      }),
    }),
  }),
  s({
    trig = "obk",
    snippetType = "autosnippet",
    dscr = "Expands 'obk' into '\\overbracket{<>}^{<>}'",
  }, {
    c(1, {
      fmta("\\ob{<>}{<>}", {
        d(1, get_visual),
        i(2),
      }),
      fmta("\\xoverbracket{<>}^{<>}", {
        d(1, get_visual),
        i(2),
      }),
    }),
  }),
  s({
    trig = "ubc",
    snippetType = "autosnippet",
    dscr = "Expands 'udb' into '\\underbrace{<>}_{<>}'",
  }, {
    c(1, {
      fmta("\\underbrace{<>}_{<>}", {
        d(1, get_visual),
        i(2),
      }),
      fmta("\\xunderbrace{<>}_{<>}", {
        d(1, get_visual),
        i(2),
      }),
    }),
  }),
  s({
    trig = "obc",
    snippetType = "autosnippet",
    dscr = "Expands 'ovb' into '\\overbrace{<>}_{<>}'",
  }, {
    c(1, {
      fmta("\\overbrace{<>}^{<>}", {
        d(1, get_visual),
        i(2),
      }),
      fmta("\\xoverbrace{<>}^{<>}", {
        d(1, get_visual),
        i(2),
      }),
    }),
  }),
  -- framed
  s(
    {
      trig = "frm",
      snippetType = "autosnippet",
      dscr = "Expands 'frm' into framed environment",
    },
    fmta(
      [[
    \begin{framed}
      <>
    \end{framed}
    ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- pybloc
  s(
    {
      trig = "pyb",
      snippetType = "autosnippet",
      dscr = "Expands 'pyb' into pybloc environment",
      condition = line_begin,
    },
    fmta(
      [[
    \begin{pyblock}
      <>
    \end{pyblock}
    ]],
      {
        d(1, get_visual),
      }
    )
  ),
  s(
    {
      trig = "pyd",
      snippetType = "autosnippet",
      dscr = "Expands 'pyd' into pycode environment",
      condition = line_begin,
    },
    fmta(
      [[
    \begin{pycode}
      <>
    \end{pycode}
    ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- py
  s({
    trig = "pyy",
    snippetType = "autosnippet",
    dscr = "Expands 'py' into '\\py{}'",
  }, fmta("\\py{<>}", { d(1, get_visual) })),
  s({
    trig = "pyc",
    snippetType = "autosnippet",
    dscr = "Expands 'pyc' into '\\pyc{}'",
  }, fmta("\\pyc{<>}", { d(1, get_visual) })),
  s({
    trig = "pyn",
    snippetType = "autosnippet",
    dscr = "Expands 'pny' into '\\py{fr'\\num{{{<>}}}'}'",
  }, fmta("\\py{fr'\\num{{{<>:.<>}}}'}", { d(1, get_visual), i(2, "2e") })),
  s(
    {
      trig = "pys",
      snippetType = "autosnippet",
      dscr = "Expands 'psy' into '\\py{fr'\\SI{{{<>}}}{{{}}}'}'",
    },
    fmta(
      "\\py{fr'\\SI{{{<>:.<>}}}{{<>}}'}",
      { d(1, get_visual), i(2, "2e"), i(3, "UNIT") }
    )
  ),
  -----------------------------------------------------------------------------
  -- Environments
  -----------------------------------------------------------------------------
  -- labels
  s(
    {
      trig = "lbl",
      snippetType = "autosnippet",
      dscr = "A label",
      condition = line_begin,
    },
    fmta(
      [[
    \label{<>:<>}
    <>
    ]],
      {
        c(1, {
          i(1, "sec"),
          i(2, "ssec"),
          i(3, "sssec"),
          i(4, "eq"),
          i(5, "tab"),
          i(6, "fig"),
        }),
        d(2, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "rf",
      snippetType = "autosnippet",
      dscr = "A reference",
    },
    fmta(
      [[
    \ref{<>:<>} <>
    ]],
      {
        c(1, {
          i(1, "sec"),
          i(2, "ssec"),
          i(3, "sssec"),
          i(4, "eq"),
          i(5, "tab"),
          i(6, "fig"),
        }),
        d(2, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "qrf",
      snippetType = "autosnippet",
      dscr = "An equation reference",
    },
    fmta(
      [[
    \eqref{eq:<>} <>
    ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- todo, fixme
  s(
    {
      trig = "tdo",
      snippetType = "autosnippet",
      dscr = "TODO",
      condition = line_begin,
    },
    fmta(
      [[
      % TODO: <>
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "fxm",
      snippetType = "autosnippet",
      dscr = "FIXME",
      condition = line_begin,
    },
    fmta(
      [[
      % FIXME: <>
      <>
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- sections
  s(
    {
      trig = "chp",
      snippetType = "autosnippet",
      dscr = "A chapter",
      condition = line_begin,
    },
    fmta(
      [[
      \chapter{<>}
      <>
      ]],
      {
        d(1, get_visual),
        c(2, { sn(1, { t("\\label{ch:"), i(1, "label"), t("}") }), t("") }),
      }
    )
  ),
  s(
    {
      trig = "sc",
      snippetType = "autosnippet",
      dscr = "A section",
      condition = line_begin,
    },
    fmta(
      [[
      \section{<>}
      <>
      ]],
      {
        d(1, get_visual),
        c(2, { sn(1, { t("\\label{sec:"), i(1, "label"), t("}") }), t("") }),
      }
    )
  ),
  s(
    {
      trig = "ssc",
      snippetType = "autosnippet",
      dscr = "A subsection",
      condition = line_begin,
    },
    fmta(
      [[
      \subsection{<>}
      <>
      ]],
      {
        d(1, get_visual),
        c(2, { sn(1, { t("\\label{ssec:"), i(1, "label"), t("}") }), t("") }),
      }
    )
  ),
  s(
    {
      trig = "sssc",
      snippetType = "autosnippet",
      dscr = "A subsubsection",
      condition = line_begin,
    },
    fmta(
      [[
      \subsubsection{<>}
      <>
      ]],
      {
        d(1, get_visual),
        c(2, { sn(1, { t("\\label{sssec:"), i(1, "label"), t("}") }), t("") }),
      }
    )
  ),
  s(
    {
      trig = "prr",
      snippetType = "autosnippet",
      dscr = "A paragraph*",
      condition = line_begin,
    },
    fmta(
      [[
      \paragraph<>{<>}
      <>
      ]],
      {
        c(1, { t("*"), t("") }),
        d(2, get_visual),
        i(0),
      }
    )
  ),
  -- generic
  s(
    {
      trig = "env",
      snippetType = "autosnippet",
      dscr = "A LaTeX environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{<>}<>
        <>
      \end{<>}
      <>
    ]],
      {
        i(1),
        c(2, { sn(1, { t("{"), i(1), t("}") }), t("") }),
        d(3, get_visual),
        rep(1),
        i(0),
      }
    )
  ),
  -- prgm
  s(
    {
      trig = "prg",
      snippetType = "autosnippet",
      dscr = "A prgm environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{prgm}
        <>
      \end{prgm}
      <>
    ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- tcolorbox
  -- main
  s({
    trig = "tcb",
    snippetType = "autosnippet",
    dscr = "A tcb environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
          \begin{tcb}(<>){<>}
            <>
          \end{tcb}
          <>
          ]],
        {
          i(1, "prop"),
          i(2),
          d(3, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcb}(<>)<<<>>>{<>}
        <>
      \end{tcb}
      <>
      ]],
        {
          i(1, "prop"),
          i(2, "lftt"),
          i(3),
          d(4, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcb}[<>](<>)<><>{<>}
        <>
      \end{tcb}
      <>
    ]],
        {
          i(1, "sidebyside"),
          i(2, "prop"),
          c(3, { t(""), fmt("<{}>", { i(1, "lft") }) }),
          c(4, { t(""), fmta('"<>"', { i(1, "bulb") }) }),
          i(5),
          d(6, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -- without number
  s({
    trig = "tcn",
    snippetType = "autosnippet",
    dscr = "A tcb environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
          \begin{tcn}(<>){<>}
            <>
          \end{tcn}
          <>
          ]],
        {
          i(1, "prop"),
          i(2),
          d(3, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcn}(<>)<<<>>>{<>}
        <>
      \end{tcn}
      <>
      ]],
        {
          i(1, "prop"),
          i(2, "lftt"),
          i(3),
          d(4, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcn}[<>](<>)<><>{<>}
        <>
      \end{tcn}
      <>
    ]],
        {
          i(1, "sidebyside"),
          i(2, "prop"),
          c(3, { t(""), fmt("<{}>", { i(1, "lft") }) }),
          c(4, { t(""), fmta('"<>"', { i(1, "bulb") }) }),
          i(5),
          d(6, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -- with star
  s({
    trig = "tcs",
    snippetType = "autosnippet",
    dscr = "A tcb starred environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
          \begin{tcb*}(<>){<>}
            <>
          \end{tcb*}
          <>
          ]],
        {
          i(1, "prop"),
          i(2),
          d(3, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcb*}(<>)<<<>>>{<>}
          <>
      \end{tcb*}
      <>
      ]],
        {
          i(1, "prop"),
          i(2, "lftt"),
          i(3),
          d(4, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{tcb*}[<>](<>)<><>{<>}
          <>
      \end{tcb*}
      <>
    ]],
        {
          i(1, "sidebyside"),
          i(2, "prop"),
          c(3, { t(""), fmt("<{}>", { i(1, "lft") }) }),
          c(4, { t(""), fmta('"<>"', { i(1, "bulb") }) }),
          i(5),
          d(6, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -- transition
  s({
    trig = "tci",
    snippetType = "autosnippet",
    dscr = "A itc environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
          \begin{tcb}(<>)<<itc>>{<>}
            <>
          \end{tcb}
          <>
          ]],
        {
          i(1, "prop"),
          i(2),
          d(3, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
          \begin{tcb}(expe)<<itc>>"<>"{<>}
            <>
          \end{tcb}
          <>
          ]],
        {
          i(1, "mate"),
          i(2),
          d(3, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
          \begin{tcb}(expe)<<itc>>"trans"{Transition}
            <>
          \end{tcb}
          <>
          ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -- tcblower
  s(
    {
      trig = "tlo",
      snippetType = "autosnippet",
      condition = line_begin,
      dscr = "Expands 'tlo' into \tcblower.",
    },
    fmta(
      [[
        \tcblower
        <>
        ]],
      { i(0) }
    )
  ),
  -- side
  s({
    trig = "isd",
    snippetType = "autosnippet",
    dscr = "A isd environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
          \begin{isd}
            <>
            \tcblower
            <>
          \end{isd}
          <>
        ]],
        {
          d(1, get_visual),
          i(2),
          i(0),
        }
      ),
      fmta(
        [[
          \begin{isd}[<>](<>)
            <>
            \tcblower
            <>
          \end{isd}
          <>
        ]],
        {
          d(1, get_visual),
          i(2, "prop"),
          i(3),
          i(4),
          i(0),
        }
      ),
    }),
  }),
  -- adaptive side
  s(
    {
      trig = "sde",
      snippetType = "autosnippet",
      dscr = "A sde environment",
      condition = line_begin,
    },
    fmta(
      [[
        \sde[<>](<>){<>}{
          <>
        }{
          <>
        }
        <>
      ]],
      {
        c(1, { fmta("right, <>", { i(1) }), fmta("left, <>", { i(1) }) }),
        i(2, "prop"),
        i(3, "Titre"),
        i(4, "Left"),
        i(5, "Right"),
        i(0),
      }
    )
  ),
  -- starred
  s(
    {
      trig = "sds",
      snippetType = "autosnippet",
      dscr = "A sds environment",
      condition = line_begin,
    },
    fmta(
      [[
        \sds[<>](<>){<>}{
          <>
        }{
          <>
        }
        <>
      ]],
      {
        c(1, { fmta("right, <>", { i(1) }), fmta("left, <>", { i(1) }) }),
        i(2, "prop"),
        i(3, "Titre"),
        i(4, "Left"),
        i(5, "Right"),
        i(0),
      }
    )
  ),
  -- subtitle
  s(
    {
      trig = "tsu",
      snippetType = "autosnippet",
      dscr = "Expands 'tsu' into '\\tcbsubtitle{\\fatbox{<>}}'",
    },
    fmta("\\tcbsubtitle{\\fatbox{<>}}", {
      d(1, get_visual),
    })
  ),
  -- hide
  s(
    {
      trig = "hde",
      snippetType = "autosnippet",
      dscr = "A hide environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{hide}
        <>
      \end{hide}
      <>
    ]],
      {
        d(1, get_visual),
        i(0),
      }
    )
  ),
  -- minipage
  s(
    {
      trig = "mp",
      snippetType = "autosnippet",
      dscr = "A minipage environment",
      condition = line_begin,
    },
    fmta(
      [[
      \noindent
      \begin{minipage}[<>]{.<>\linewidth}
        <>
      \end{minipage}
    ]],
      { i(1), i(2), d(3, get_visual) }
    )
  ),
  -- minifigure
  s(
    {
      trig = "mf",
      snippetType = "autosnippet",
      dscr = "A minifigure environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{minipage}[<>]{.<>\linewidth}
        \vspace{0pt}
        \begin{center}
          \includegraphics[<>=<>]{<>}
          <>
          \label{fig:<>}
        \end{center}
      \end{minipage}
      <>
    ]],
      {
        i(1, "t"),
        i(2),
        -- c(3, { t("width"), t("scale"), t("height") }),
        i(3, "width"),
        i(4),
        i(5),
        c(6, { t(""), sn(1, { t("\\captionof{figure}{"), i(1), t("}") }) }),
        i(7),
        i(0),
      }
    )
  ),
  -- center
  s(
    {
      trig = "cnt",
      snippetType = "autosnippet",
      dscr = "A center environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{center}
        <>
      \end{center}
      <>
    ]],
      { d(1, get_visual), i(0) }
    )
  ),
  -- auto item
  s({
    trig = "it",
    snippetType = "autosnippet",
    dscr = "An item",
    condition = line_begin,
  }, {
    c(1, {
      fmta("\\item <>", { d(1, get_visual) }),
      fmta("\\item[b]{<>}", { d(1, get_visual) }),
      fmta("\\item[n]{<>}", { d(1, get_visual) }),
      fmta("\\item[cl]{<>} <>", { i(1), i(2) }),
      fmta("\\item[sq]{<>} <>", { i(1), i(2) }),
      fmta("\\item[<>]", { d(1, get_visual) }),
    }),
  }),
  -- auto task
  s({
    trig = "tk",
    snippetType = "autosnippet",
    dscr = "A task",
    condition = line_begin,
  }, {
    c(1, {
      fmta("\\task <>", { d(1, get_visual) }),
      fmta("\\task[<>] <>", { i(1), d(2, get_visual) }),
      fmta("\\task*(<>) <>", { i(1), d(2, get_visual) }),
    }),
  }),
  -- itemize
  s(
    {
      trig = "tm",
      snippetType = "autosnippet",
      dscr = "An itemize environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{itemize}<>
        <>
      \end{itemize}
      <>
    ]],
      {
        c(1, {
          t(""),
          fmta("[label=$\\<>$]", { i(1, "diamond") }),
          fmta(
            "[label=$\\<>$, leftmargin=<>pt]",
            { i(1, "diamond"), i(2, "10") }
          ),
          fmta("[<>]", { i(1) }),
        }),
        c(2, {
          fmta("\\item <>", { d(1, get_visual) }),
          fmta("\\item[b]{<>}", { d(1, get_visual) }),
          fmta("\\item[n]{<>}", { d(1, get_visual) }),
          fmta("\\item[cl]{<>} <>", { i(1), i(2) }),
          fmta("\\item[sq]{<>} <>", { i(1), i(2) }),
          fmta("\\item[<>]", { d(1, get_visual) }),
        }),
        i(0),
      }
    )
  ),
  -- tasks
  s(
    {
      trig = "tsk",
      snippetType = "autosnippet",
      dscr = "A tasks environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{tasks}<>(<>)
        <>
      \end{tasks}
      <>
    ]],
      {
        c(1, {
          t(""),
          fmta("[label=\\protect\\fbox{<>}]", { i(1, "\\Alph*") }),
          fmta(
            "[label=\\protect\\fbox{<>}, label-width=<>]",
            { i(1, "\\Alph*"), i(2, "4ex") }
          ),
          fmta("[<>]", { i(1) }),
        }),
        i(2, "4"),
        d(3, get_visual),
        i(0),
      }
    )
  ),
  -- enumerate
  s(
    {
      trig = "enu",
      snippetType = "autosnippet",
      dscr = "An enumerate environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{enumerate}<>
        <>
      \end{enumerate}
      <>
    ]],
      {
        c(1, {
          t(""),
          fmta("[<>]", { i(1, "label=\\Roman*") }),
          fmta("[<>]", { i(1, "label=\\sqenumi") }),
          fmta("[<>]", { i(1, "resume") }),
        }),
        c(2, {
          fmta("\\item <>", { d(1, get_visual) }),
          fmta("\\item[b]{<>}", { d(1, get_visual) }),
          fmta("\\item[n]{<>}", { d(1, get_visual) }),
          fmta("\\item[cl]{<>} <>", { i(1), i(2) }),
          fmta("\\item[sq]{<>} <>", { i(1), i(2) }),
          fmta("\\item[<>]", { d(1, get_visual) }),
        }),
        i(0),
      }
    )
  ),
  -- generic
  s(
    {
      trig = "env",
      snippetType = "autosnippet",
      dscr = "A LaTeX environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{<>}<>
        <>
      \end{<>}
      <>
    ]],
      {
        i(1),
        c(2, { sn(1, { t("{"), i(1), t("}") }), t("") }),
        d(3, get_visual),
        rep(1),
        i(0),
      }
    )
  ),
  -- raster
  s(
    {
      trig = "rst",
      snippetType = "autosnippet",
      dscr = "A tcbraster environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{tcbraster}[raster equal height=rows, raster columns=<>]
        <>
      \end{tcbraster}
      <>
    ]],
      {
        i(1, "2"),
        d(2, get_visual),
        i(0),
      }
    )
  ),
  -- gather
  s({
    trig = "gth",
    snippetType = "autosnippet",
    dscr = "A gather environment",
    condition = line_begin,
  }, {
    c(1, {
      fmta(
        [[
      \begin{gather*}
        <>
      \end{gather*}
      <>
      ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
      fmta(
        [[
      \begin{gather}
        <>
      \end{gather}
      <>
      ]],
        {
          d(1, get_visual),
          i(0),
        }
      ),
    }),
  }),
  -----------------------------------------------------------------------------
  -- Figures
  -----------------------------------------------------------------------------
  -- include simple
  s(
    {
      trig = "grf",
      snippetType = "autosnippet",
      dscr = "Include graphics",
    },
    fmta(
      [[
      \includegraphics[<>=<>]{<>}
      ]],
      { c(1, { t("width"), t("scale"), t("height") }), i(2), i(3) }
    )
  ),
  s({
    trig = "lwd",
    wordTrig = false,
    snippetType = "autosnippet",
    dscr = "Linewidth",
  }, {
    t("\\linewidth"),
  }),
  -- s({
  --   trig = "([=%d])lwd",
  --   regTrig = true,
  --   wordTrig = false,
  --   snippetType = "autosnippet",
  --   dscr = "Linewidth",
  -- }, {
  --   f(function(_, snip)
  --     return snip.captures[1]
  --   end),
  --   t("\\linewidth"),
  -- }),
  -- fig
  s(
    {
      trig = "fig",
      snippetType = "autosnippet",
      dscr = "A figure environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{figure}[<>]
        \centering
        \includegraphics[<>=<>]{<>}
        <>
        \caption{<>}
        \label{fig:<>}
      \end{figure}
      <>
    ]],
      {
        i(1),
        c(2, { t("width"), t("scale"), t("height") }),
        i(3),
        i(4),
        c(5, { t(""), t("\\captionsetup{justification=centering}") }),
        i(6),
        i(7),
        i(0),
      }
    )
  ),
  -- wrapfig
  s(
    {
      trig = "wfg",
      snippetType = "autosnippet",
      dscr = "A wrapfig environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{wrapfigure}[<>]{<>}{.<>\linewidth}
        \centering
        \includegraphics[<>=<>]{<>}
        <>
        \caption{<>}
        \label{fig:<>}
      \end{wrapfigure}
      <>
    ]],
      {
        i(1, "LINENUM"),
        i(2, "R"),
        i(3),
        c(4, { t("width"), t("scale"), t("height") }),
        i(5),
        i(6),
        c(7, { t(""), t("\\captionsetup{justification=centering}") }),
        i(8),
        i(9),
        i(0),
      }
    )
  ),
  -- caption
  s({
    trig = "cpt",
    snippetType = "autosnippet",
    dscr = "captions",
    condition = line_begin,
  }, {
    c(1, {
      fmta("\\caption{<>}", {
        d(1, get_visual),
      }),
      fmta("\\captionof{figure}{<>}", {
        d(1, get_visual),
      }),
    }),
  }),
  -- centering caption
  s({
    trig = "cpc",
    snippetType = "autosnippet",
    dscr = "center caption",
    condition = line_begin,
  }, {
    t("\\captionsetup{justification=centering}"),
  }),
  -----------------------------------------------------------------------------
  -- Tables
  -----------------------------------------------------------------------------
  -- include simple
  s(
    {
      trig = "tbr",
      snippetType = "autosnippet",
      dscr = "Include tabular(x)",
    },
    fmta(
      [[
        \begin<>{<>}
          \toprule
          <>
          \\
          \bottomrule
        \end{<>}
        <>
      ]],
      {
        c(1, {
          t("{tabular}"),
          fmta(
            "{tabularx}{<>}",
            { c(1, { t("\\linewidth"), fmta(".<>\\linewidth", { i(1) }) }) }
          ),
        }),
        i(2),
        i(3),
        c(4, { t("tabular"), t("tabularx") }),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "tbl",
      snippetType = "autosnippet",
      dscr = "A table environment",
      condition = line_begin,
    },
    fmta(
      [[
      \begin{table}[<>]
        \centering
        \caption{<>}
        <>
        \label{tab:<>}
      \end{table}
      <>
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
      }
    )
  ),
  s({
    trig = "tpr",
    snippetType = "autosnippet",
    dscr = "toprule",
    condition = line_begin,
  }, { t("\\toprule") }),
  s({
    trig = "mdr",
    snippetType = "autosnippet",
    dscr = "midrule",
    condition = line_begin,
  }, { t("\\midrule") }),
  s({
    trig = "btr",
    snippetType = "autosnippet",
    dscr = "bottomrule",
    condition = line_begin,
  }, { t("\\bottomrule") }),
  s({
    trig = "cmr",
    snippetType = "autosnippet",
    dscr = "cmidrule",
    condition = line_begin,
  }, fmta("\\cmidrule(<>){<>}", { i(1, "lr"), i(2, "range") })),
  -----------------------------------------------------------------------------
  -- TikZ
  -----------------------------------------------------------------------------
  -- Basic
  s({
    trig = "drw",
    snippetType = "autosnippet",
    dscr = "draw",
    condition = line_begin or tex_utils.in_tikz,
  }, fmta("\\draw[<>] <>;", { i(1), i(2) })),
  s(
    {
      trig = "nde",
      snippetType = "autosnippet",
      dscr = "node",
      condition = line_begin or tex_utils.in_tikz,
    },
    fmta(
      "\\node[<>]<> at (<>) {<>};",
      { i(1), c(2, { t(""), fmta(" (<>)", { i(1) }) }), i(3), d(4, get_visual) }
    )
  ),
  s(
    {
      trig = "Nde",
      snippetType = "autosnippet",
      dscr = "node inline",
      condition = line_begin or tex_utils.in_tikz,
    },
    fmta(
      "node[<>]<> {<>}",
      { i(1), c(2, { t(""), fmta(" (<>)", { i(1) }) }), d(3, get_visual) }
    )
  ),
  s(
    {
      trig = "crd",
      snippetType = "autosnippet",
      dscr = "coord",
      condition = line_begin or tex_utils.in_tikz,
    },
    fmta(
      "\\coordinate<> (<>) at (<>);",
      { c(1, { t(""), fmta("[label={<>:<>}]", { i(1), i(2) }) }), i(2), i(3) }
    )
  ),
  s(
    {
      trig = "Crd",
      snippetType = "autosnippet",
      dscr = "coord inline",
      condition = line_begin or tex_utils.in_tikz,
    },
    fmta(
      "coordinate<> (<>)",
      { c(1, { t(""), fmta("[label={<>:<>}]", { i(1), i(2) }) }), i(2) }
    )
  ),
  -- shorthand of words
  s({
    trig = "thk",
    snippetType = "autosnippet",
    condition = tex_utils.in_tikz,
  }, {
    c(1, { t("thick"), t("very thick"), t("ultra thick") }),
  }),
  s({
    trig = "stl",
    snippetType = "autosnippet",
    condition = tex_utils.in_tikz,
  }, {
    c(1, { t("-stealth"), t("stealth-") }),
  }),
  s({
    trig = "Stl",
    snippetType = "autosnippet",
    condition = tex_utils.in_tikz,
  }, fmta("-{Stealth[scale=<>]}", { i(1) })),
  -- Intelligent stuff
  s(
    {
      trig = "prp",
      snippetType = "autosnippet",
      dscr = "perpendicular",
      condition = line_begin or tex_utils.in_tikz,
    },
    fmta(
      [[
      \draw[<>]
      (<>)
      --
      ($(<>)!<>!90:(<>)$);
      <>
      ]],
      { i(1), i(2, "start"), rep(2), i(3, "length"), i(4, "end"), i(0) }
    )
  ),
}
