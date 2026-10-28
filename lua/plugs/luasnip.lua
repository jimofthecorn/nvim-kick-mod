local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add {{
    src = gh 'L3MON4D3/LuaSnip',
}}

local luasnip = require("luasnip")
luasnip.setup {}

configpath = vim.fn.stdpath('config')
require("luasnip.loaders.from_lua").load({paths = configpath .. "/lua/snippets"})

vim.keymap.set({ "i" }, "<C-K>",
    function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end,
    { silent = true }
)
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() require('luasnip.extras.select_choice')() end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })
