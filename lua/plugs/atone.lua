local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add {{
    src = gh 'jimofthecorn/atone.nvim',
    version = 'jac',
}}

require('atone').setup {
    width = 0.25,
    keymaps = {
        tree = {
            quit = { "<C-c>", "q" },
            next_node = "j", -- support v:count
            pre_node = "k", -- support v:count
            jump_to_G = "G",
            jump_to_gg = "gg",
            undo_to = "<CR>",
            set_mark = "m",
            delete_mark = { "x", "X" },
            delete_all_marks = "dM",
            goto_mark = { "'", "`" },
            mark_picker = "s",
            help = { "?", "g?" },
            float_diff = "gd",
        },
        auto_diff = {
            quit = { "<C-c>", "q" },
            help = { "?", "g?" },
            undo = "u",
            redo = "<C-r>",
            float_diff = "gd",
        },
        help = {
            quit_help = { "<C-c>", "q" },
        },
    },
    diff_float = {
        --- width of the diff float as a fraction of the editor width (0–1)
        width = 0.9,
        --- height of the diff float as a fraction of the editor height (0–1)
        height = 0.9,
        --- close the centred diff float when it loses focus.
        autoclose = true,
    },
    ui = {
        -- refer to `:h 'winborder'`
        border = "single",
        -- compact graph style
        compact = false,
        node_label = {
            custom = false,
            ---@param ctx AtoneNodeLabelContext
            ---@return AtoneNodeLabel
            formatter = function(ctx)
                return string.format("[%d] %s %s", ctx.seq, ctx.h_time, ctx.bookmark or "")
            end,
            extmark_opts = { strict = false },
        },
    },
}
