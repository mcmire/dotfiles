return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
  init = function()
    local autoPairs = require 'nvim-autopairs'
    vim.keymap.set('n', '<Leader>apt', function()
      print 'Toggling auto-pairs'
      autoPairs.toggle()
    end)
  end,
}
