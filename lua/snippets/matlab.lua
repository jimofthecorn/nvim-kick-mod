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

local get_filename = function(args, parent)
    local filename = parent.snippet.env.TM_FILENAME
    local splitname = _G.split_filename(filename)
    -- print(vim.inspect(splitname))
    return sn(nil, { i(1, splitname.stem) })
end

ls.add_snippets("matlab", {
    s("fn", fmta([[
        function <returns> = <funcname>(<args>)
            <body>
        end
        ]],
        {
            returns = i(1, "returns"),
            funcname = d(2, get_filename),
            args = i(3, "args"),
            body = i(4, "body")
        }
    )),

    s("cls", fmta([[
        classdef <classname> <is_handle>
            properties (SetAccess = <setaccess>, GetAccess = <getaccess>)
                <props>
            end
            methods
                <funcs>
            end
        end
        ]],
        {
            classname = d(1, get_filename),
            is_handle = c(2, {
                t(" "), t("< handle")
            }),
            setaccess = c(3, {
                t("public"), t("private"), t("protected")
            }),
            getaccess = c(4, {
                t("public"), t("private"), t("protected")
            }),
            props = i(5, ""),
            funcs = i(6, "")
        }
    )),

    s("prop", fmta("<name> (<shape>) <datatype> {}<setdefault>",
        {
            name = i(1, "prop"),
            shape = i(2, "1,1"),
            datatype = c(3, { t("double"), t("int64"), t("single"), t("int8"), t("logical") }),
            setdefault = c(4, { t(""), sn(nil, { t(" = "), i(1, "0") } ) } )
        }
    )),

    s("val", fmta("<val>",
        {
            val = c(1, {
                t("mustBeNumeric"),
                t("mustBeInteger"),
                t("mustBePositive"),
                t("mustBeNegative"),
                t("mustBeNonnegative"),
                t("mustBeNonpositive"),
                t("mustBeNonzero"),
                t("mustBeNonempty"),
                t("mustBeReal"),
                sn(nil, {t(" mustBeGreaterThan("), i(1, "c"), t(")")}),
                sn(nil, {t(" mustBeGreaterThanOrEqual("), i(1, "c"), t(")")}),
                sn(nil, {t(" mustBeLessThan("), i(1, "c"), t(")")}),
                sn(nil, {t(" mustBeLessThanOrEqual("), i(1, "c"), t(")")}),
                sn(nil, {t(" mustBeBetween("), i(1, "lo"), t(", "), i(2, "hi"), t(")")})
            })
        }
    )),
})

