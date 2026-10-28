local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

vim.pack.add {{
    src = gh 'jimofthecorn/termim.nvim.git',
    version = 'jimofthecorn'
}}

local termim = require 'termim'

local get_win_shell = function()
    local vs_script_paths = {
        [1] = "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat",
        [2] = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat",
    }
    local vs_script = ''
    for _, path in ipairs(vs_script_paths) do
        if vim.fn.filereadable(path) then
            vs_script = path
            break
        end
    end
    local native_shell = ''
    if vs_script == '' then
        native_shell = 'cmd'
    else
        native_shell = 'cmd /K "' .. vs_script .. '"'
    end
    return native_shell
end

local native_shell = ''

if vim.fn.has('win32') == 1 then
    native_shell = get_win_shell()
else
    native_shell = 'bash'
end

local default_shell = ''
if vim.fn.executable('nu') then
    if vim.fn.has('win32') == 1 then
        default_shell = 'nu'
    else
        default_shell = 'bash -c ~/.config/nushell/start_nushell.sh'
    end
else
    default_shell = native_shell
end

-- using the termim plugin (advantage is that splits/tabs close when shell exits)
vim.keymap.set('n', '<leader>tv', '<cmd>Vterm ' .. default_shell .. '<cr>', { desc = '[t]erminal [v]Split' })
vim.keymap.set('n', '<leader>th', '<cmd>Sterm ' .. default_shell .. '<cr>', { desc = '[t]erminal [h]Split' })
vim.keymap.set('n', '<leader>tt', '<cmd>Fterm ' .. default_shell .. '<cr>', { desc = '[t]erminal [t]ab' })
vim.keymap.set('n', '<leader>to', '<cmd>terminal! ' .. default_shell .. '<cr>', { desc = '[t]erminal [o]pen' })
vim.keymap.set('n', '<leader>tV', '<cmd>Vterm ' .. native_shell .. '<cr>',
    { desc = '[t]erminal [V]Split (native shell)' })
vim.keymap.set('n', '<leader>tH', '<cmd>Sterm ' .. native_shell .. '<cr>',
    { desc = '[t]erminal [H]Split (native shell)' })
vim.keymap.set('n', '<leader>tT', '<cmd>Fterm ' .. native_shell .. '<cr>', { desc = '[t]erminal [T]ab (native shell)' })
vim.keymap.set('n', '<leader>tO', '<cmd>terminal! ' .. native_shell .. '<cr>',
    { desc = '[t]erminal [O]pen (native shell)' })

-- lazygit
if vim.fn.executable('lazygit') == 1 then
    _G.lazygit = function()
        if vim.fn.has('win32') == 1 then
            vim.cmd('Fterm start-ssh-agent & lazygit')
        else
            vim.cmd('Fterm lazygit')
        end
    end
    vim.keymap.set('n', '<leader>gl', _G.lazygit, { desc = '[g]it [l]azyGit' })
else
    vim.notify('lazygit not found')
end

if vim.fn.executable('vifm') == 1 then
    -- vim.keymap.set('n', '<leader>tf', '<cmd>FloatermNew --height=1.0 --width=1.0 --autoclose=2 vifm<cr>', {desc = '[t]erminal vi[f]m (file manager)'})
    vim.keymap.set('n', '<leader>tf',
        function () vim.cmd('Fterm vifm') end,
        { desc = '[t]erminal vi[f]m (file manager)' }
    )
else
    vim.notify('vifm not found')
end
