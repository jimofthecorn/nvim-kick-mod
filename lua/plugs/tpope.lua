local function gh(repo) return 'https://github.com/' .. repo end

-- Grug-Far search plugin

vim.pack.add {
    gh 'tpope/vim-abolish',
    gh 'tpope/vim-fugitive',
    gh 'tpope/vim-unimpaired',
}

vim.keymap.set("n", "<leader>Gvs", "<cmd>Gvsplit ", { noremap = true, desc = "fu[G]itive [vs]plit" })
vim.keymap.set("n", "<leader>Gvd", "<cmd>Gvdiffsplit ", { noremap = true, desc = "fu[G]itive [vd]iffsplit" })

