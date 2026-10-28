local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { gh 'nvim-lualine/lualine.nvim' }

local colors = {
    black   = '#000000',
    dark_gray    = '#202020',
    dark_blue    = '#000060',
    maroon  = '#800000',
    green   = '#008000',
    olive   = '#808000',
    navy    = '#000080',
    purple  = '#800080',
    teal    = '#007070',
    teal_dark    = '#004040',
    silver  = '#c0c0c0',
    gray    = '#404040',
    red     = '#ff0000',
    lime    = '#00ff00',
    yellow  = '#ffff00',
    yellow_dark  = '#aaaa00',
    orange  = '#ffbb00',
    orange_dark  = '#aa8800',
    blue    = '#0000ff',
    fuchsia = '#ff00ff',
    cyan    = '#00ffff',
    white   = '#ffffff',
}

require('lualine').setup {
    options = {
        theme = '16color',
        icons_enabled = true,
        component_separators = { left = '', right = ''},
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''}
    },
    sections = {
        lualine_a = {
            {'mode',
                color = function(section)
                    local mode_code = vim.api.nvim_get_mode().mode
                    if mode_code == 'i' then
                        return { bg = colors.red, fg = colors.white }
                    elseif mode_code == 'v' or mode_code == 'V' then
                        return { bg = colors.orange, fg = colors.black }
                    elseif mode_code == 't' then
                        return { bg = colors.purple, fg = colors.white }
                    elseif mode_code == 'c' then
                        return { bg = colors.cyan, fg = colors.black }
                    else
                        return { bg = colors.teal, fg = colors.white }
                    end
                end
            },
        },
        lualine_b = {
            {'branch', color = { fg=colors.yellow, bg=colors.gray, gui='bold'} },
            {'diff', color = { fg=colors.red, bg=colors.dark_gray, gui='bold'} },
            {'diagnostics', color = { fg=colors.red, bg=colors.dark_blue, gui='bold'} },
        },
        lualine_c = {
            {
                'filename', path = 3, shorting_target = 60,
                color = { fg=colors.orange, bg=colors.black }
            }
        },
        lualine_x = {
            -- 'encoding',
            {'filetype', color = { fg=colors.orange, bg=colors.gray, gui='bold'} },
            {'fileformat', color = { fg=colors.white, bg=colors.gray } },
        },
        -- lualine_y = {},
        lualine_y = {
            {
                'location',
                color = { fg = colors.white, bg = colors.teal_dark }
            },
        },
        lualine_z = {
            {'progress', color = { fg=colors.white, bg=colors.teal_dark } }
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {
            {'branch', color = { fg=colors.yellow_dark, bg=colors.gray, gui='bold'} },
        },
        lualine_c = {
            {
                'filename', path = 4, shorting_target = 60,
                color = { fg=colors.orange_dark, bg=colors.black }
            }
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                'location',
                color = { fg = colors.white, bg = colors.teal_dark }
            },
        },
    }
}
