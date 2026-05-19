return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    enabled = false,
  },
  init = function()
    vim.keymap.set('n', '<leader>mrt', require('render-markdown').toggle)
  end,
}
