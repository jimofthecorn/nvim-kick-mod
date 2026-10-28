local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

vim.pack.add { gh 'folke/trouble.nvim' }
local trouble = require 'trouble'
trouble.setup {
}

vim.keymap.set('n', "<leader>Td",
    "<cmd>Trouble diagnostics toggle<cr>",
    { desc = "[T]rouble [d]iagnostics" }
)
vim.keymap.set('n', "<leader>Tb",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { desc = "[T]rouble [b]uffer diagnostics" }
)
vim.keymap.set('n', "<leader>Ts",
    "<cmd>Trouble symbols toggle focus=false<cr>",
    { desc = "[T]rouble [s]ymbols" }
)
vim.keymap.set('n', "<leader>TL",
    "<cmd>Trouble lsp toggle focus=false<cr>",
    { desc = "[T]rouble [L]SP Definitions / references / ..." }
)
vim.keymap.set('n', "<leader>Tl",
    "<cmd>Trouble loclist toggle<cr>",
    { desc = "[T]rouble [l]ocation List" }
)
vim.keymap.set('n', "<leader>Tq",
    "<cmd>Trouble qflist toggle<cr>",
    { desc = "[T]rouble toggle [q]uickfixlist" }
)
