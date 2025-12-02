return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'base16',
    },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1,
        },
      },
    },
  },
}
