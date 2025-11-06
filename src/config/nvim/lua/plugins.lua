-- *******
-- Plugins
-- *******

require('lazy').setup {
  spec = {
    require 'plugins.abolish',
    require 'plugins.autoclose',
    require 'plugins.blink-cmp',
    require 'plugins.conform',
    require 'plugins.copilot',
    require 'plugins.ctrlp',
    require 'plugins.eunuch',
    require 'plugins.indent-blankline',
    require 'plugins.lazydev',
    require 'plugins.mini',
    require 'plugins.neo-tree',
    require 'plugins.nvim-lspconfig',
    require 'plugins.nvim-rg',
    require 'plugins.nvim-surround',
    require 'plugins.nvim-treesitter-endwise',
    require 'plugins.nvim-treesitter',
    require 'plugins.splitjoin',
    require 'plugins.tinted',
    --require 'plugins.todo-comments',
    require 'plugins.which-key',
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}
