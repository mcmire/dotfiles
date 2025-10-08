-- *******
-- Plugins
-- *******

require('lazy').setup {
  -- List of plugins.
  --
  -- Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()`
  --   function, forcing the plugin to be loaded.
  --
  -- Alternatively, use `config = function() ... end` for full control over the
  -- configuration.
  --
  -- For instance, if you prefer to call `setup` explicitly:
  --
  --    {
  --      'lewis6991/gitsigns.nvim',
  --      config = function()
  --        require('gitsigns').setup({
  --          -- Your gitsigns configuration here
  --        })
  --      end,
  --    }
  --
  spec = {
    require 'plugins.which-key',
    require 'plugins.telescope',
    require 'plugins.lazydev',
    require 'plugins.nvim-lspconfig',
    require 'plugins.conform',
    require 'plugins.blink',
    require 'plugins.selenized',
    require 'plugins.todo-comments',
    require 'plugins.mini',
    require 'plugins.nvim-treesitter',
    require 'plugins.neotree',
    require 'plugins.rg',
    require 'plugins.autoclose',
    require 'plugins.nvim-treesitter-endwise',
    require 'plugins.simpleIndentGuides',
    require 'plugins.nvim-surround',
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
