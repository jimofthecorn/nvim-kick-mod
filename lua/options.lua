-- just to suppress all the lsp warnings...
local vim = vim

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

_G.python_path = ''
local nvrpath = ''

if vim.fn.has('win32') == 1 then
    _G.python_path = vim.fn.expand('$HOME//py_nvim/Scripts/python.exe')
    nvrpath = vim.fn.expand('$HOME//py_nvim/Scripts/nvr.exe')

    vim.g.winaltkeys = 'menu'
else
    _G.python_path = vim.fn.expand('$HOME/py_nvim/bin/python3')
    nvrpath = vim.fn.expand('$HOME/py_nvim/bin/nvr')
end

if vim.uv.fs_stat(_G.python_path) then
    vim.g.python3_host_prog=_G.python_path
    vim.g.black_virtualenv=_G.python_path

    -- local pip_stuff = vim.cmd("!" .. _G.python_path .. " -m pip list")
    -- if not string.find(pip_stuff, "pynvim") then
    --     vim.cmd("!" .. _G.python_path .. " -m pip install pynvim")
    -- end
    if not vim.uv.fs_stat(nvrpath) then
        vim.cmd("!" .. _G.python_path .. " -m pip install neovim-remote")
    end
else
    vim.notify("Did not find python.exe at ".._G.python_path, vim.log.levels.WARN)
end

-- use ripgrep for grep
if vim.fn.executable('rg') == 1 then
    vim.o.grepprg="rg --vimgrep --smart-case --follow"
end

-- [[ Setting options ]]
--  See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- automatically cd to current file
vim.o.autochdir = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.o.number = true

-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- make movements wrap at start/end of lines
vim.o.whichwrap = vim.o.whichwrap .. 'b,s,h,l,<,>,[,]'

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Disable swap file
vim.o.swapfile = false

vim.o.wrap = false
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- keep cursor away from bottom & right edges of screen (e.g. for search results)
vim.o.scrolloff = 3
vim.o.sidescrolloff = 10

-- make cursor more visible
vim.o.guicursor='n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = false
-- vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = false
vim.o.listchars = "tab:<->,lead:⋅,trail:✠,nbsp:+,multispace:◆"

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Functions related to options

vim.api.nvim_create_user_command(
    'ToggleIgnoreCase',
    function()
        vim.o.ignorecase = not vim.o.ignorecase
        print('ignorecase = ' .. (vim.o.ignorecase and 'true' or 'false'))
    end,
    {}
)

-- autocmd to set current buffer workind directory to file path
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function()
        vim.cmd('silent! lcd %:p:h')
    end,
    pattern = { '*' },
})
--
-- vim: ts=2 sts=2 sw=2 et
