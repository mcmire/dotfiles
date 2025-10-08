return {
  'LucasTavaresA/simpleIndentGuides.nvim',
  event = 'VimEnter',
  config = function()
    vim.opt.list = true -- enable in all buffers
    require('simpleIndentGuides').setup '┊'
  end,
}
