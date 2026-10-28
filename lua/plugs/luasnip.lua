local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add {{
    src = gh 'L3MON4D3/LuaSnip',
}}

require('luasnip').setup {}
