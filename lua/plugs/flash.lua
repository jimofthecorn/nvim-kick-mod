local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add {{
    src = gh 'folke/flash.nvim',
}}

require('flash').setup {}

vim.keymap.set({'n','x', 'o'}, 's',
    function()
        require("flash").jump()
    end,
    { desc = "Flash" }
)
