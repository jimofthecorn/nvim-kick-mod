local function gh(repo) return 'https://github.com/' .. repo end
local cmdparse = require 'mega.cmdparse'
local vim = vim

vim.pack.add { gh 'folke/snacks.nvim' }
local Snacks = require 'snacks'
Snacks.setup {
  image = {
    enabled = not(vim.fn.has('win32')),
  },
  dashboard = {
    preset = {
      keys = {
        { icon = "󰱼 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "s", desc = "Find File (smart)", action = ":lua Snacks.dashboard.pick('smart')" },
        { icon = " ", key = "z", desc = "Zoxide find directory", action = ":lua Snacks.dashboard.pick('zoxide')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "g", desc = "Grep for Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = "󱦞 ", key = "t", desc = "Close Tab", action = close_tab_if_possible, enabled = extra_tab_pages },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    -- your dashboard configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    sections = {
      { section = "header" },
      { section = "keys",  gap = 1, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Recent Files",
        section = "recent_files",
        limit = 8,
        indent = 2,
        padding = 1,
      },
      {
        pane = 2,
        icon = " ",
        title = "Projects",
        section = "projects",
        limit = 8,
        indent = 2,
        padding = 1,
      },
      -- this now causes nvim to start in insert mode
      -- {
      --   pane = 2,
      --   icon = " ",
      --   title = "Git Status",
      --   section = "terminal",
      --   enabled = function()
      --     return Snacks.git.get_root() ~= nil
      --   end,
      --   cmd = "git status --short --branch --renames",
      --   height = 5,
      --   padding = 1,
      --   ttl = 5 * 60,
      --   indent = 3,
      -- },
    },
  },
  picker = {
    -- your picker configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    formatters = {
    },
    main = {
      file = false,
    },
    layouts = {
      default = {
        layout = {
          box = 'horizontal',
          width = 0.95,
          min_width = 120,
          height = 0.95,
          {
            box = 'vertical',
            border = 'rounded',
            title = '{title} {live} {flags}',
            { win = 'input', height = 1,   border = 'bottom' },
            { win = 'list',  border = 'none' },
          },
          {
            win = 'preview',
            title = '{preview}',
            border = 'rounded',
            width = 0.5
          },
        },
      },
    },
    actions = {
      trouble_qflist = function(picker)
        local actions = require("snacks.picker.actions")
        actions.qflist(picker)
        vim.cmd("cclose | Trouble qflist")
      end,
    },
    win = {
      -- input window
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          -- ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
          ["<c-l>"] = { "edit_vsplit", mode = { "i", "n" } },
          ["<c-t>"] = { "trouble_qflist", mode = { "i", "n" } },
        }
      }
    }
  },
  explorer = {
    -- your explorer configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    replace_netrw = true, -- Replace netrw with the snacks explorer
  },
  lazygit = {
    -- your lazygit configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    win = {
      height = 0.95,
      width = 0.95,
    },
    scope = {
      -- your scope configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      enabled = true,
    },
  }
}

local snacks_functions = function()
    Snacks.picker.lsp_symbols(
        { filter = { default = {"Function", "Method", "Constructor"} } }
    )
end
local function snacks_dim_toggle()
    if Snacks.dim.enabled then
        Snacks.dim.disable()
    else
        Snacks.dim.enable()
    end
end
vim.keymap.set("n", "<leader>D", snacks_dim_toggle, { desc = "toggle [D]im" })

vim.keymap.set("n", "<leader>gb", Snacks.git.blame_line, { desc = "[g]it [b]lame line" })

vim.keymap.set("n", "<leader><space>", Snacks.picker.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sf", Snacks.picker.files, { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>sD",
    function() Snacks.picker.files({cwd = "~/devel"}) end,
    { desc = "[s]earch files in ~/[D]evel" }
)
vim.keymap.set("n", "<leader>ce",
    function() Snacks.picker.files({cwd = vim.fn.stdpath('config')}) end,
    { desc = "[c]onfig [e]dit" }
)
vim.keymap.set("n", "<leader>s~",
    function() Snacks.picker.files({cwd = "~", hidden = true}) end,
    { desc = "[s]earch files in [~]/home directory" }
)
vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>sw", Snacks.picker.grep_word, { desc = "[s]earch current [w]ord in current dir" })
vim.keymap.set("n", "<leader>sW",
    function()
        local git_root = _G.find_git_root()
        if #git_root == 0 then
            Snacks.picker.grep_word({ title = "Grep Word in cwd"  })
        else
            Snacks.picker.grep_word({ cwd = git_root, title = "Grep Word in git repo"})
        end
    end,
    { desc = "[s]earch current [W]ord in git repo" }
)

vim.keymap.set("n", "<leader>sl", Snacks.picker.lines, { desc = "[s]earch [l]ines" })
vim.keymap.set("n", "<leader>sg", Snacks.picker.grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sG", Snacks.picker.git_grep, { desc = "[s]earch by [G]rep on git root" })
vim.keymap.set("n", "<leader>sL", Snacks.picker.git_log, { desc = "[s]earch git [L]og" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, {desc = "[s]earch [k]eymaps"})
vim.keymap.set("n", "<leader>sR", Snacks.picker.resume, { desc = "[s]earch [R]esume" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "[s]earch [d]iagnostics" })
vim.keymap.set("n", "<leader>sc", Snacks.picker.commands, {desc = "[s]earch [c]ommands"})
vim.keymap.set("n", "<leader>sC", Snacks.picker.command_history, {desc = "[s]earch [C]ommand history"})
vim.keymap.set("n", "<leader>sH", Snacks.picker.search_history, {desc = "[s]earch search [H]istory"})
-- vim.keymap.set("n", "<leader>sb", Snacks.picker.lgrep_curbuf, {desc = "[s]earch current [b]uffer"})
vim.keymap.set("n", "<leader>sb", Snacks.picker.grep_buffers, {desc = "[s]earch open [b]uffers"})
vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, {desc = "[s]earch [q]uickfix"})
-- vim.keymap.set("n", "<leader>sQ", Snacks.picker.quickfix_stack, {desc = "[s]earch [Q]uickfix history"})
vim.keymap.set("n", "<leader>sr", Snacks.picker.recent, {desc = "[s]earch [r]ecent files"})
vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, {desc = "[s]earch [m]arks"})
vim.keymap.set("n", "<leader>sR", Snacks.picker.registers, {desc = "[s]earch [R]egisters"})
vim.keymap.set("n", "<leader>sz", Snacks.picker.zoxide, {desc = "[s]earch [z]oxide"})
vim.keymap.set("n", "<leader>sp", Snacks.picker.projects, {desc = "[s]earch [p]rojects"})
vim.keymap.set("n", "<leader>ss", Snacks.picker.smart, {desc = "[s]earch [s]mart"})
-- vim.keymap.set("n", "<leader>cc", mycolorschemes, {desc = "[c]hoose [c]olorscheme"})

-- function picker
vim.keymap.set("n", "<leader>sS", snacks_functions, {desc = "[s]earch [S]ymbols"})

-- find_files() but starting from git root (git_files() only searches *tracked* files)
-- if not a git repo, falls back to cwd
local git_search_func = _G.search_from_git_root(Snacks.picker.files)
vim.keymap.set("n", "<leader>sF", git_search_func, { desc = "[s]earch git [F]iles" })

local search_todo_comments = function()
    local git_root = _G.find_git_root()
    local opts = { search = "#(\\ *)(FIX|BUG|FIX|FIXME|TODO|HACK|WARN|NOTE|INFO|TEST)\\>" }
    if #git_root == 0 then
        opts.title = "Find TODO comments in cwd"
    else
        opts.title = "Find TODO comments in git repo"
        opts.cwd = git_root
    end
    Snacks.picker.grep(opts)
end
vim.keymap.set("n", "<leader>sT",
    search_todo_comments,
    { desc = "[s]earch [T]odo comments" }
)

local function basename(file_path)
    local file_name = file_path:match("[^/\\]+$") -- Match the file name after the last '/' or '\'
    return file_name or file_path -- If no '/' or '\' found, return the whole path as filename
end

local function calc_max_len(bm_list, field)
    local max = 0
    for _, item in ipairs(bm_list) do
        local fld = item[field]
        local val
        if type(fld) == "table" then
            val = "(" .. table.concat(fld, ",") .. ")"
        else
            val = tostring(fld)
        end
        if #val > max then
            max = #val
        end
    end
    return max
end

local function pad_str(str, max_len, before)
    if #str < max_len then
        if not before then
            return str .. string.rep(" ", max_len - #str)
        else
            return string.rep(" ", max_len - #str) .. str
        end
    else
        return str
    end
end

local drop_path_segment = function(p)
    return vim.api.nvim_call_function("fnamemodify", {p, ":h"})
end
local get_tail_path_segment = function(p)
    return vim.api.nvim_call_function("fnamemodify", {p, ":t"})
end

local snacks_search_git_repos = nil

if vim.fn.executable("fd") then
    snacks_search_git_repos = function()
        local dotgit_paths = vim.fn.systemlist("fd '\\.git$' ~ -H -t d")
        local repo_items = {}
        for i, p in ipairs(dotgit_paths) do
            local repo = drop_path_segment(drop_path_segment(p))
            local name = get_tail_path_segment(repo)
            table.insert(repo_items,
                {
                    idx = i,
                    name = name,
                    file = repo,
                    dir = true,
                }
            )
        end
        local max_len = calc_max_len(repo_items, "name")
        local crop_len = 24
        local snack_items = {}
        for _, item in ipairs(repo_items) do
            local name = item.name
            if #name > crop_len-2 then
                name = string.sub(name, 1, crop_len-2) .. ".."
            end
            item["text"] = pad_str(name, crop_len, false) .. " " .. item.file
            table.insert(snack_items, item)
        end
        return Snacks.picker({
            items = snack_items,
            format = "text",
            confirm = "load_session",
        })
    end

    vim.keymap.set("n", "<leader>gs", snacks_search_git_repos, { desc = "[g]it [s]earch for repos" })

else
    vim.notify("fn executable not found")
end

local function add_padded_fields(bm_list, fields)
    for _, field in ipairs(fields) do
        local max_len = calc_max_len(bm_list, field)
        for _, item in ipairs(bm_list) do
            if field == "lnum" then
                before = true
            else
                before = false
            end
            for _, item in ipairs(bm_list) do
                local fld = item[field]
                local val
                if type(fld) == "table" then
                    val = "(" .. table.concat(fld, ",") .. ")"
                else
                    val = tostring(fld)
                end

                item[field .. "_padded"] = pad_str(val, max_len, before)
            end
        end
    end
    return bm_list
end

if vim.fn.executable("odin") then
    local odinlib_path = vim.fn.system('odin root')
    local odin_devel_path = _G.get_home_path() .. "/devel/odin"
    local odin_example_path = odin_devel_path .. "/examples"

    local function set_odin_keymaps(key_str, path, desc_table)
        vim.keymap.set("n", key_str .. "f",
            function() Snacks.picker.files({ cwd = path }) end,
            { desc = desc_table[1] }
        )
        vim.keymap.set("n", key_str .. "w",
            function() Snacks.picker.grep_word({ cwd = path }) end,
            { desc = desc_table[2] }
        )
        vim.keymap.set("n", key_str .. "g",
            function() Snacks.picker.grep({ cwd = path }) end,
            { desc = desc_table[3] }
        )
    end

    if odinlib_path ~= nil then
        -- if we have a valid odinlib_path path, set it as the default cwd for the odin picker
        set_odin_keymaps("<leader>sO", odinlib_path,
            {
                "[s]earch [O]din lib [f]iles",
                "[s]earch in [O]din lib for current [w]ord",
                "[s]earch in [O]din lib by [g]rep",
            }
        )
    else
        -- print error message
        vim.notify("Could not find odinlib path", vim.log.levels.WARN)
    end

    set_odin_keymaps("<leader>sOD", odin_devel_path,
        {
            "[s]earch [O]din [D]evel [f]iles",
            "[s]earch in [O]din [D]evel for current [w]ord",
            "[s]earch in [O]din [D]evel by [g]rep",
        }
    )
    set_odin_keymaps("<leader>sOE", odin_example_path,
        {
            "[s]earch files in ~/[O]din [E]xamples [f]iles",
            "[s]earch in [O]din [E]xamples for current [w]ord",
            "[s]earch in [O]din [E]xamples by [g]rep",
        }
    )
end

-- Ex commands

local function create_snacks_commands()
    local parser = cmdparse.ParameterParser.new({ name = "Snacks", help = "Snacks commands" })
    local top_subparsers = parser:add_subparsers({ destination = "commands" })

    -- buffers
    local buffers = top_subparsers:add_parser({ name = "buffers", help = "Snacks search buffers & switch" })
    buffers:set_execute(Snacks.picker.buffers)

    -- files (smart)
    local smart = top_subparsers:add_parser({ name = "smart", help = "Snacks search files (smart)" })
    smart:set_execute(Snacks.picker.smart)

    -- recent files
    local recent = top_subparsers:add_parser({ name = "recent", help = "Snacks search recent files" })
    recent:set_execute(Snacks.picker.recent)

    local notifications = top_subparsers:add_parser({ name = "notifications", help = "Notification History" })
    notifications:set_execute(Snacks.picker.notifications)

    local explorer = top_subparsers:add_parser({ name = "explorer", help = "File Explorer" })
    explorer:set_execute(Snacks.picker.explorer)

    -- git branches
    local branches = top_subparsers:add_parser({ name = "branches", help = "Snacks search git branches" })
    branches:add_parameter({ names = {"--all", "-a"}, action="store_true", help="git branches [-a/--all]" })
    local gitbranchfunc = function(args)
        if args.namespace.all then
            Snacks.picker.git_branches({ all = true })
        else
            Snacks.picker.git_branches()
        end
    end
    branches:set_execute(gitbranchfunc)

    -- git log
    local gitlog = top_subparsers:add_parser({ name = "gitlog", help = "search git log" })
    gitlog:add_parameter({ names = {"--line", "-l"}, action="store_true", help="git log for current line" })
    local gitlogfunc = function(args)
        if args.namespace.line then
            Snacks.picker.git_log_line()
        else
            Snacks.picker.git_log()
        end
    end
    gitlog:set_execute(gitlogfunc)

    -- neovim config files
    local configfiles = top_subparsers:add_parser({ name = "nvim", help = "search neovim config files" })
    configfiles:set_execute(function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end)

    local files = top_subparsers:add_parser({ name = "files", help = "Find Files" })
    files:set_execute(Snacks.picker.files)

    local git_files = top_subparsers:add_parser({ name = "git_files", help = "Find Git Files" })
    git_files:set_execute(Snacks.picker.git_files)

    local projects = top_subparsers:add_parser({ name = "projects", help = "Projects" })
    projects:set_execute(Snacks.picker.projects)

-- -- git
    
    if vim.fn.executable("fd") then
        local git_repos = top_subparsers:add_parser({ name = "git_repos", help = "Git Repositories" })
        git_repos:set_execute(snacks_search_git_repos)
    end

    local git_status = top_subparsers:add_parser({ name = "git_status", help = "Git Status" })
    git_status:set_execute(Snacks.picker.git_status)

    local git_stash = top_subparsers:add_parser({ name = "git_stash", help = "Git Stash" })
    git_stash:set_execute(Snacks.picker.git_stash)

    local git_diff = top_subparsers:add_parser({ name = "git_diff", help = "Git Diff (Hunks)" })
    git_diff:set_execute(Snacks.picker.git_diff)

    local git_log_file = top_subparsers:add_parser({ name = "git_log_file", help = "Git Log File" })
    git_log_file:set_execute(Snacks.picker.git_log_file)

    local gitbrowse = top_subparsers:add_parser({ name = "gitbrowse", help = "Git Browse" })
    gitbrowse:set_execute(Snacks.picker.gitbrowse)

    -- local lazygit = top_subparsers:add_parser({ name = "lazygit", help = "Lazygit" })
    -- lazygit:set_execute(Snacks.picker.lazygit)

    local gh_issue = top_subparsers:add_parser({ name = "gh_issue", help = "GitHub Issues (open)" })
    gh_issue:set_execute(Snacks.picker.gh_issue)

    local gh_issue_all = top_subparsers:add_parser({ name = "gh_issue_all", help = "GitHub Issues (all)" })
    gh_issue_all:set_execute(function() Snacks.picker.gh_issue_all({ state = "all" }) end)

    local gh_pr = top_subparsers:add_parser({ name = "gh_pr", help = "GitHub Pull Requests (open)" })
    gh_pr:set_execute(Snacks.picker.gh_pr)

    local gh_pr_all = top_subparsers:add_parser({ name = "gh_pr_all", help = "GitHub Pull Requests (all)" })
    gh_pr_all:set_execute(function() Snacks.picker.gh_pr({ state = "all" }) end)

    local lines = top_subparsers:add_parser({ name = "lines", help = "Buffer Lines" })
    lines:set_execute(Snacks.picker.lines)

    local grep_buffers = top_subparsers:add_parser({ name = "grep_buffers", help = "Grep Open Buffers" })
    grep_buffers:set_execute(Snacks.picker.grep_buffers)

    local grep = top_subparsers:add_parser({ name = "grep", help = "Grep" })
    grep:set_execute(Snacks.picker.grep)

    local grep_word = top_subparsers:add_parser({ name = "grep_word", help = "Grep for visual selection or word" })
    grep_word:set_execute(Snacks.picker.grep_word)

    local registers = top_subparsers:add_parser({ name = "registers", help = "Registers" })
    registers:set_execute(Snacks.picker.registers)

    local search_history = top_subparsers:add_parser({ name = "search_history", help = "Search History" })
    search_history:set_execute(Snacks.picker.search_history)

    local autocmds = top_subparsers:add_parser({ name = "autocmds", help = "Autocmds" })
    autocmds:set_execute(Snacks.picker.autocmds)

    local command_history = top_subparsers:add_parser({ name = "command_history", help = "Command History" })
    command_history:set_execute(Snacks.picker.command_history)

    local commands = top_subparsers:add_parser({ name = "commands", help = "Commands" })
    commands:set_execute(Snacks.picker.commands)

    local diagnostics = top_subparsers:add_parser({ name = "diagnostics", help = "Diagnostics" })
    diagnostics:set_execute(Snacks.picker.diagnostics)

    local diagnostics_buffer = top_subparsers:add_parser({ name = "diagnostics_buffer", help = "Buffer Diagnostics" })
    diagnostics_buffer:set_execute(Snacks.picker.diagnostics_buffer)

    local help = top_subparsers:add_parser({ name = "help", help = "Help Pages" })
    help:set_execute(Snacks.picker.help)

    local highlights = top_subparsers:add_parser({ name = "highlights", help = "Highlights" })
    highlights:set_execute(Snacks.picker.highlights)

    local icons = top_subparsers:add_parser({ name = "icons", help = "Icons" })
    icons:set_execute(Snacks.picker.icons)

    local jumps = top_subparsers:add_parser({ name = "jumps", help = "Jumps" })
    jumps:set_execute(Snacks.picker.jumps)

    local keymaps = top_subparsers:add_parser({ name = "keymaps", help = "Keymaps" })
    keymaps:set_execute(Snacks.picker.keymaps)

    local loclist = top_subparsers:add_parser({ name = "loclist", help = "Location List" })
    loclist:set_execute(Snacks.picker.loclist)

    local marks = top_subparsers:add_parser({ name = "marks", help = "Marks" })
    marks:set_execute(Snacks.picker.marks)

    local man = top_subparsers:add_parser({ name = "man", help = "Man Pages" })
    man:set_execute(Snacks.picker.man)

    local lazy = top_subparsers:add_parser({ name = "lazy", help = "Search for Plugin Spec" })
    lazy:set_execute(Snacks.picker.lazy)

    local qflist = top_subparsers:add_parser({ name = "qflist", help = "Quickfix List" })
    qflist:set_execute(Snacks.picker.qflist)

    local resume = top_subparsers:add_parser({ name = "resume", help = "Resume" })
    resume:set_execute(Snacks.picker.resume)

    local undo = top_subparsers:add_parser({ name = "undo", help = "Undo History" })
    undo:set_execute(Snacks.picker.undo)

    -- local colorschemes = top_subparsers:add_parser({ name = "colorschemes", help = "Colorschemes" })
    -- colorschemes:set_execute(Snacks.picker.colorschemes)

-- -- LSP
    local lsp_definitions = top_subparsers:add_parser({ name = "lsp_definitions", help = "Goto Definition" })
    lsp_definitions:set_execute(Snacks.picker.lsp_definitions)

    local lsp_declarations = top_subparsers:add_parser({ name = "lsp_declarations", help = "Goto Declaration" })
    lsp_declarations:set_execute(Snacks.picker.lsp_declarations)

    local lsp_references = top_subparsers:add_parser({ name = "lsp_references", help = "References" })
    lsp_references:set_execute(Snacks.picker.lsp_references)

    local lsp_implementations = top_subparsers:add_parser({ name = "lsp_implementations", help = "Goto Implementation" })
    lsp_implementations:set_execute(Snacks.picker.lsp_implementations)

    local lsp_type_definitions = top_subparsers:add_parser({ name = "lsp_type_definitions", help = "Goto T[y]pe Definition" })
    lsp_type_definitions:set_execute(Snacks.picker.lsp_type_definitions)

    local lsp_incoming_calls = top_subparsers:add_parser({ name = "lsp_incoming_calls", help = "C[a]lls Incoming" })
    lsp_incoming_calls:set_execute(Snacks.picker.lsp_incoming_calls)

    local lsp_outgoing_calls = top_subparsers:add_parser({ name = "lsp_outgoing_calls", help = "C[a]lls Outgoing" })
    lsp_outgoing_calls:set_execute(Snacks.picker.lsp_outgoing_calls)

    local lsp_symbols = top_subparsers:add_parser({ name = "lsp_symbols", help = "LSP Symbols" })
    lsp_symbols:set_execute(Snacks.picker.lsp_symbols)

    local lsp_workspace_symbols = top_subparsers:add_parser({ name = "lsp_workspace_symbols", help = "LSP Workspace Symbols" })
    lsp_workspace_symbols:set_execute(Snacks.picker.lsp_workspace_symbols)

    local lsp_functions = top_subparsers:add_parser({ name = "functions", help = "Functions/Methods" })
    lsp_functions:set_execute(snacks_functions)

    local zen = top_subparsers:add_parser({ name = "zen", help = "Zen Mode" })
    zen:set_execute(Snacks.zen)

    -- local zoom = top_subparsers:add_parser({ name = "zoom", help = "Toggle Zoom" })
    -- zoom:set_execute(Snacks.zen.zoom)

-- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    -- local select = top_subparsers:add_parser({ name = "select", help = "Select Scratch Buffer" })
    -- select:set_execute(Snacks.scratch.select)

    local show_history = top_subparsers:add_parser({ name = "show_history", help = "Notification History" })
    show_history:set_execute(Snacks.notifier.show_history)

    local bufdelete = top_subparsers:add_parser({ name = "bufdelete", help = "Delete Buffer" })
    bufdelete:set_execute(Snacks.notifier.bufdelete)

    local rename_file = top_subparsers:add_parser({ name = "rename_file", help = "Rename File" })
    rename_file:set_execute(Snacks.rename.rename_file)

    local hide = top_subparsers:add_parser({ name = "hide", help = "Dismiss All Notifications" })
    hide:set_execute(Snacks.notifier.hide)

    -- local nextref = top_subparsers:add_parser({ name = "nextref", help = "Next Reference" })
    -- nextref:set_execute(function() Snacks.words.jump(vim.v.count1) end)
    --
    -- local prevref = top_subparsers:add_parser({ name = "prevref", help = "Prev Reference" })
    -- prevref:set_execute(function() Snacks.words.jump(-vim.v.count1) end)

-- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
-- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    --
    cmdparse.create_user_command(parser)
end

create_snacks_commands()
