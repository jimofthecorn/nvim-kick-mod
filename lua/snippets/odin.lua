local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
    s("proc", fmta([[
            <procname> :: proc(<args>) ->> <returns> {
                <body>
            }
        ]],
        {
            procname = i(1, "<myproc>"),
            args = i(2, "<params>"),
            -- returns = c(3, {
            --     { t(" ->> "), i(2, "<returns> ") },
            --     t(" "),
            -- }),
            returns = i(3, "<returns>"),
            body = i(4, "<body>")
        }
    )),

    s("dbgprnt", fmta([[
            fmt.println("<varname> = ", <varname2>)
        ]],
        {
            varname = i(1, "x"),
            varname2 = rep(1),
        }
    )),
    
    s("make", fmta([[
            <slice>, <err1> := make(<argtype>, <num><alloc>)
            if <err2> != .None {
                fmt.printfln("memory allocation error: %v", <errmsg>)
                return <return_vals>
            }
        ]],
        {
            slice = i(1, "slice"),
            err1 = i(2, "err"),
            argtype = i(3, "[]type"),
            num = i(4, "10"),
            alloc = c(5, {t"", t", allocator"}),
            err2 = rep(2),
            errmsg = i(6, "\"fail!\""),
            return_vals = i(7, "nil, false")
        }
    )),
    
    s("unswitch", fmta([[
        switch <val> in <unionval> {
        case <type1>:
            <body1>
        case <type2>:
            <body2>
        }

        ]],
        {
            val = i(1, "v"),
            unionval = i(2, "val"),
            type1 = i(3, "mem.Allocator_Error"),
            body1 = i(4, "..."),
            type2 = i(5, "bool"),
            body2 = i(6, "..."),
        }
    )),
    
    s("switch", fmta([[
        switch <val> {
        case .<enum1>:
            <body1>
        case .<enum2>:
            <body2>
        }

        ]],
        {
            val = i(1, "v"),
            enum1 = i(2, "Foo"),
            body1 = i(3, "..."),
            enum2 = i(4, "Bar"),
            body2 = i(5, "..."),
        }
    )),
}
