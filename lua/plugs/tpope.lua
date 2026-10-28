local function gh(repo) return 'https://github.com/' .. repo end

-- Grug-Far search plugin

vim.pack.add {
    gh 'tpope/vim-abolish',
    gh 'tpope/vim-fugitive',
    gh 'tpope/vim-unimpaired',
}
