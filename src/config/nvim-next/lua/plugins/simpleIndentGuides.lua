return {
  'LucasTavaresA/simpleIndentGuides.nvim',
  event = 'VimEnter',
  config = function()
    require('simpleIndentGuides').setup '┊'
  end,
}
