-- Load plugin modules in order.

require 'plugs.cmdparse'
require 'plugs.snacks'
require 'plugs.guess-indent'
require 'plugs.gitsigns'
require 'plugs.termim'
require 'plugs.which-key'
require 'plugs.colors'
require 'plugs.todo-comments'
require 'plugs.mini'
require 'plugs.lspconfig'
require 'plugs.conform'
require 'plugs.blink-cmp'
require 'plugs.treesitter'

-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
-- require 'plugs.debug'
-- require 'plugs.indent_line'
-- require 'plugs.lint'
-- require 'plugs.autopairs'
-- require 'plugs.neo-tree'

-- NOTE: You can add your own plugins, configuration, etc. in `lua/custom/plugins/*.lua`.
--
-- For independent modules, uncomment the convenience loader:
-- require 'custom.plugins'
--
-- `custom.plugins` automatically loads files from that directory, but their
-- order is unspecified. If plugins depend on each other, keep them in the same
-- file and put their `vim.pack.add()` and `setup()` calls in the required order.
--
-- If separate modules need a specific order, require them explicitly instead:
-- require 'custom.plugins.colorscheme'
-- require 'custom.plugins.ui'
-- require 'custom.plugins.git'

-- vim: ts=2 sts=2 sw=2 et
