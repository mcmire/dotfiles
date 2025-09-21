return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    {
      '<Leader>tt',
      ':Neotree reveal<CR>',
      desc = 'NeoTree reveal',
      silent = true,
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<Leader>tt'] = 'close_window',
        },
      },
    },
  },
}
