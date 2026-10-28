local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- Grug-Far search plugin

vim.pack.add { gh 'MagicDuck/grug-far.nvim' }
local grug = require 'grug-far'
grug.setup {}

-- search & replace starting in current file only
vim.keymap.set("n", "<leader>gf", function()
     grug.open(
         {
             prefills = {
                 paths = vim.fn.expand("%"),
             }
         })
     end,
    { noremap = true, silent = true, desc = "[g]rug-[f]ar (this file)" }
)
-- search & replace word under cursor starting in current file only
vim.keymap.set("n", "<leader>gw", function()
     grug.open(
         {
             prefills = {
                 search = vim.fn.expand("<cword>"),
                 paths = vim.fn.expand("%"),
             }
         })
     end,
    { noremap = true, silent = true, desc = "[g]rug-far current [w]ord (this file)" }
)
-- search & replace in entire project
vim.keymap.set("n", "<leader>gF", function()
     grug.open(
         {
         })
     end,
    { noremap = true, silent = true, desc = "[g]rug-[f]ar" }
)
-- search & replace word under cursor
vim.keymap.set("n", "<leader>gW", function()
     grug.open(
         {
             prefills = {
                 search = vim.fn.expand("<cword>"),
             }
         })
     end,
    { noremap = true, silent = true, desc = "[g]rug-far current [W]ord" }
)

