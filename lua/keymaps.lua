-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local vim = vim

-- I forget, what is this for?
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- print word count
vim.keymap.set('n', '<leader>wc',
    function() vim.notify(vim.fn.wordcount().words .. " words") end,
    { noremap = true, silent = true, desc = '[w]ord [c]ount' }
)
-- closer than Esc
vim.keymap.set('i', 'jk', '<Esc>')

vim.keymap.set('n', '<leader>cs', function() vim.cmd('colorscheme') end)

vim.keymap.set('n', '<C-W>h', '<cmd>split<cr>',
    { noremap = true, desc = "[w]indow split [h]orizontally" }
)
vim.keymap.set('n', '<C-W>v', '<cmd>vsplit<cr>',
    { noremap = true, desc = "[w]indow split [v]ertically" }
)
vim.keymap.set('n', '<C-W>M', function () _G.resize_window(0.99) end,
    { noremap = true, desc = "[w]indow [M]aximize" }
)
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>',
    { noremap = true, desc = "[w]indow split [h]orizontally" }
)
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>',
    { noremap = true, desc = "[w]indow split [v]ertically" }
)
vim.keymap.set('n', '<leader>wm', function () _G.resize_window(0.99) end,
    { noremap = true, desc = "[w]indow [m]aximize" }
)

-- change window size more easily (didn't even realize this wasn't builtin)
vim.keymap.set('n', '-', '<C-w><')
vim.keymap.set('n', '+', '<C-w>>')

-- toggle show whitespace
vim.keymap.set('n', '<leader>wt', '<cmd>set list!<cr>', { noremap = true, desc = "[w]hitespace [t]oggle" })

-- tabs
vim.keymap.set("n", "<leader>ta", '<cmd>tabnew<cr>', { noremap = true, desc = "[t]ab [a]dd" })
vim.keymap.set("n", "<leader>tc", '<cmd>tabclose<cr>', { noremap = true, desc = "[t]ab [c]lose" })
-- vim.keymap.set("n", "<leader>to", '<cmd>tabonly<cr>', { noremap = true })
vim.keymap.set("n", "<leader>tn", '<cmd>tabn<cr>', { noremap = true, desc = "[t]ab [n]ext" })
vim.keymap.set("n", "<leader>tp", '<cmd>tabp<cr>', { noremap = true, desc = "[t]ab [p]revious" })
vim.keymap.set("n", "<leader>tr", ':Tabby rename_tab ', { noremap = true, desc = "[t]ab [r]ename" })

-- windows
vim.keymap.set("n", "<leader>wdt", '<cmd>windo diffthis<cr>', { noremap = true, desc = "[w]indo [d]iff [t]his" })
vim.keymap.set("n", "<leader>wdo", '<cmd>windo diffoff<cr>', { noremap = true, desc = "[w]indo [d]iff [o]ff" })
vim.keymap.set("n", "<leader>wS",
    function()
        vim.cmd('windo set scrollbind!')
        vim.notify("scrollbind set to " .. tostring(vim.o.scrollbind), vim.log.levels.INFO)
    end,
    { noremap = true, desc = "[w]indo [S]crollbind toggle" }
)

-- display full path of current file
vim.keymap.set('n', '<leader>cp', '<cmd>echo expand("%:p")<cr>', { desc = '[c]urrent [p]ath' })

-- vim.keymap.set('n', '<leader>cr', '<cmd>ReloadConfig<cr>', { desc = '[c]onfig [r]eload' })

-- make exiting terminal mode work
vim.keymap.set('t', '<Esc><Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', 'jk', '<C-\\><C-n>')

-- quickfixlist
vim.keymap.set('n', '<leader>qo', '<cmd>copen<cr>', { desc = '[q]uickfix [o]pen' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>', { desc = '[q]uickfix [c]lose' })
vim.keymap.set('n', '<leader>qv', '<cmd>cfdo vsplit %<cr>', { desc = '[q]uickfix open files in [v]splits' })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- vim: ts=2 sts=2 sw=2 et
