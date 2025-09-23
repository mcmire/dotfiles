return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  -- neo-tree lazily loads itself
  lazy = false,
  keys = {
    {
      '<Leader>tt',
      ':Neotree action=show toggle=true<CR>',
      desc = 'Neo[T]ree: [T]oggle',
      silent = true,
    },
    {
      '<Leader>tf',
      ':Neotree action=focus reveal=true<CR>',
      desc = 'Neo[T]ree: [F]ocus current file',
      silent = true,
    },
  },
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    filesystem = {
      window = {
        mappings = {
          -- Compatibility with NERDTree
          ['i'] = 'open_split',
        },
      },
    },
  },
}
