local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ Snippet Engine ]]

-- NOTE: You can also specify plugin using a version range for its git tag.
--  See `:help vim.version.range()` for more info
vim.pack.add {
    { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
    gh 'hrsh7th/nvim-cmp',
    gh 'saadparwaiz1/cmp_luasnip',
    gh 'hrsh7th/cmp-nvim-lsp',
}

local luasnip = require("luasnip")
luasnip.setup {}

local cmp = require('cmp')

configpath = vim.fn.stdpath('config')
require("luasnip.loaders.from_lua").load({paths = configpath .. "/lua/snippets"})

cmp.setup {
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    window = {
        completion = cmp.config.window.bordered(
            { max_width = 50 }
        ),
        documentation = cmp.config.window.bordered(
            {
                min_width = 60,
                max_width = 0,
            }
        )
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-g>'] = cmp.mapping.complete {},
        ['<C-e>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
    },
}

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
