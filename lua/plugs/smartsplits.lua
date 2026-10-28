local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

vim.pack.add { gh 'smart-splits-nvim/smart-splits.nvim' }
local splits = require 'smart-splits'
splits.setup {
    swap = {
        move_cursor = false,
    },
}

local resize_left = function(amount)
    local fn = function() splits.resize_left(amount) end
    return fn
end
local resize_down = function(amount)
    local fn = function() splits.resize_down(amount) end
    return fn
end
local resize_up = function(amount)
    local fn = function() splits.resize_up(amount) end
    return fn
end
local resize_right = function(amount)
    local fn = function() splits.resize_right(amount) end
    return fn
end
vim.keymap.set('n', '<A-h>', resize_left(3), { noremap = true, desc = "Window resize left" })
vim.keymap.set('n', '<A-j>', resize_down(1), { noremap = true, desc = "Window resize down" })
vim.keymap.set('n', '<A-k>', resize_up(1), { noremap = true, desc = "Window resize up" })
vim.keymap.set('n', '<A-l>', resize_right(3), { noremap = true, desc = "Window resize right" })

-- moving between splits
vim.keymap.set('n', '<C-h>', splits.move_cursor_left, { noremap = true, desc = "Jump to left Window" })
vim.keymap.set('n', '<C-j>', splits.move_cursor_down, { noremap = true, desc = "Jump to down Window" })
vim.keymap.set('n', '<C-k>', splits.move_cursor_up, { noremap = true, desc = "Jump to up Window" })
vim.keymap.set('n', '<C-l>', splits.move_cursor_right, { noremap = true, desc = "Jump to right Window" })

-- swapping buffers between windows
vim.keymap.set('n', '<leader>wsh', splits.swap_buf_left, { noremap = true, desc = "[w]indow [s]wap left [h]" })
vim.keymap.set('n', '<leader>wsj', splits.swap_buf_down, { noremap = true, desc = "[w]indow [s]wap down [j]" })
vim.keymap.set('n', '<leader>wsk', splits.swap_buf_up, { noremap = true, desc = "[w]indow [s]wap up [k]" })
vim.keymap.set('n', '<leader>wsl', splits.swap_buf_right, { noremap = true, desc = "[w]indow [s]wap right [l]" })
