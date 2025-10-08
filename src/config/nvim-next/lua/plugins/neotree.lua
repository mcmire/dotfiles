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
      ':Neotree action=focus toggle=true<CR>',
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
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          -- Change type
          added = 'A',
          deleted = 'D',
          modified = 'M',
          renamed = 'R',
          -- Status type
          untracked = '?',
          ignored = '#',
          unstaged = 'O',
          staged = '@',
          conflict = 'x',
        },
      },
    },
    window = {
      mappings = {
        -- Compatibility with NERDTree
        ['i'] = 'open_split',
      },
    },
  },
}
