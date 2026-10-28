local function gh(repo) return 'https://github.com/' .. repo end
local vim = vim

---@type (string|vim.pack.Spec)[]
local mega_plugins = {
  gh 'ColinKennedy/mega.logging',
  gh 'ColinKennedy/mega.cmdparse',
}
-- NOTE: You can install multiple plugins at once
vim.pack.add(mega_plugins)

