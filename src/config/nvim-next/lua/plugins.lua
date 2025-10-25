-- *******
-- Plugins
-- *******

require('lazy').setup {
  spec = {
    require 'plugins.autoclose',
    require 'plugins.abolish',
    require 'plugins.blink',
    require 'plugins.conform',
    require 'plugins.ctrlp',
    require 'plugins.eunuch',
    require 'plugins.indentmini',
    require 'plugins.lazydev',
    --require 'plugins.markview',
    require 'plugins.mini',
    require 'plugins.neo-tree',
    --require 'plugins.nerdtree',
    require 'plugins.nvim-lspconfig',
    require 'plugins.nvim-surround',
    require 'plugins.nvim-treesitter',
    require 'plugins.nvim-treesitter-endwise',
    --require 'plugins.render-markdown',
    require 'plugins.rg',
    require 'plugins.selenized',
    --require 'plugins.simpleIndentGuides',
    require 'plugins.splitjoin',
    --require 'plugins.telescope',
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
