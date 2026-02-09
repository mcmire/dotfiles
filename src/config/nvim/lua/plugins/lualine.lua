return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'base16',
    },
    sections = {
      lualine_b = {
        {
          'b:gitsigns_head',
          icon = '',
        },
      },
      lualine_c = {
        {
          'filename',
          path = 1,
        },
      },
    },
  },
}
