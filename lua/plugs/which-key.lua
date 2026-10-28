local function gh(repo) return 'https://github.com/' .. repo end

-- Useful plugin to show you pending keybinds.
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  win = {
    width = { min = 30, max = 100 },
    height = { min = 6, max = 0.9 },
    padding = { 1, 1 },
    col = 0.5,
    row = 0.5,
    border = "rounded",
    title = true,
    title_pos = "center",
  },
  layout = {
    width = { min = 30 },
  },
  -- Document existing key chains
  spec = {
    { "<leader>b", group = '[b]ookmarks' },
    { "<leader>c", group = '[c]ode' },
    { "<leader>d", group = '[d]ocument' },
    { "<leader>G", group = '[G]it-fugitive' },
    { "<leader>g", group = '[g]it, [g]rug-far' },
    { "<leader>h", group = 'git-gutter [h]unk' },
    { "<leader>l", group = '[l]sp' },
    { "<leader>q", group = '[q]uickfix' },
    { "<leader>r", group = '[r]ename' },
    { "<leader>s", group = '[s]earch' },
    { "<leader>t", group = '[t]erminal, [t]ab' },
    { "<leader>T", group = '[T]rouble' },
    { "<leader>w", group = '[w]indow' },
    { "<leader>W", group = '[W]orkspace' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
