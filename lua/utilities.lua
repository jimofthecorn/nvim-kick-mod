local vim = vim
local create_command = vim.api.nvim_create_user_command

function _G.reload_config()
    for name, _ in pairs(package.loaded) do
        if name:match('^cnull') then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)
end

vim.api.nvim_create_user_command('ReloadConfig', _G.reload_config, {})

function _G.is_module_available(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

function _G.resize_window(width, height)
    if width == nil then
        vim.notify(
            "resize_window() requires at least 1 dimension",
            vim.log.levels.ERROR
        )
    end
    if height == nil then
        height = width
    end
    if width < 1 then
        width = math.floor(vim.o.columns * width)
    end
    if height < 1 then
        height = math.floor(vim.o.lines * height)
    end
    vim.api.nvim_win_set_width(0, width)
    vim.api.nvim_win_set_height(0, height)
end

function _G.split_filename(filename)
    local filestem, extension = filename:match("^(.+)%.(.+)$")
    return { stem = filestem, extension = extension }
end
--
-- function to convert camelCase to snake_case
function _G.camel_to_snake(camelCase)
    local snakeCase = ""
    for i = 1, #camelCase do
        local char = string.sub(camelCase, i, i)
        if string.match(char, "%a") then                           -- Check if the character is a word character
            if snakeCase ~= "" and string.upper(char) == char then -- Check if the character is uppercase
                snakeCase = snakeCase .. "_"
            end
            snakeCase = snakeCase .. string.lower(char)
        else -- Non-word character
            snakeCase = snakeCase .. char
        end
    end
    return snakeCase
end

-- function to get listed buffers
function _G.get_listed_bufs()
    local buflist = vim.api.nvim_list_bufs()
    local listed_bufs = {}
    for _, bufnr in ipairs(buflist) do
        if vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
            table.insert(listed_bufs, bufnr)
        end
    end
    return listed_bufs
end

-- set some options for editing prose
function _G.set_text_mode()
    vim.b.wrap = true
    vim.b.linebreak = true
    vim.b.textwidth = 78
    vim.b.wrapmargin = 5
    vim.b.spell = true
    vim.b.spelllang = 'en_us'
    vim.b.colorcolumn = '78'
end

-- set some options for coding
function _G.set_code_mode()
    vim.b.wrap = false
    vim.b.linebreak = true
    vim.b.textwidth = 78
    vim.b.wrapmargin = 0
    vim.b.colorcolumn = '72'
end

vim.api.nvim_create_user_command('TextMode', _G.set_text_mode, {})
vim.api.nvim_create_user_command('CodeMode', _G.set_code_mode, {})

-- Function to find the git root directory based on the current buffer"s path
function _G.find_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    if #dot_git_path == 0 then
        return dot_git_path
    end
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

if vim.fn.executable('git') then
    function _G.is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
    end

    -- find_files() but starting from git root (git_files() only searches *tracked* files)
    -- if not a git repo, falls back to cwd
    function _G.search_from_git_root(searcher)
        local search_func = function(opts)
            if _G.is_git_repo() then
                opts = {
                    cwd = _G.find_git_root(),
                }
            end
            searcher(opts)
        end
        return search_func
    end

end

function _G.file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else return false end
end

function _G.search_func_with_opts(searcher, my_opts)
    if not my_opts then my_opts = {} end
    return function(opts)
        if not opts then opts = {} end
        for k, v in pairs(my_opts) do opts[k] = v end
        searcher(opts)
    end
end

function _G.get_home_path()
    if vim.fn.has('win32') == 1 then
        return os.getenv('USERPROFILE')
    else
        return os.getenv('HOME')
    end
end

-- two funcs to create split and search for something to put in it
--
function _G.split_search_bufs(searcher, split_type, opts)
    if not opts then opts = {} end
    return function(opts)
        vim.cmd(split_type)
        searcher(opts)
    end
end

function _G.split_search_git_files(searcher, split_type, opts)
    if not opts then opts = {} end
    local func = _G.search_from_git_root(searcher)
    return function(opts)
        vim.cmd(split_type)
        func(opts)
    end
end

function _G.safe_require(module_name)
    local status_ok, module = pcall(require, module_name)
    if not status_ok then
        vim.notify(
            string.format("Error loading module '%s': %s", module_name, module),
            vim.log.levels.ERROR
        )
        return nil
    end
    return module
end

function _G.start_timer(func, interval_msec)
    local repeat_func = function()
        local keep_running = func()
        if keep_running then
            _G.start_timer(func, interval_msec)
        end
    end
    vim.defer_fn(repeat_func, interval_msec)
end
local time_count = 0
function _G.print_time()
    local t = os.date("*t")
    vim.notify("The time is " .. t.hour .. ":" .. t.min .. ":" .. t.sec, vim.log.levels.INFO)
    time_count = time_count + 1
    if time_count > 5 then
        return false
    end
    return true
end
