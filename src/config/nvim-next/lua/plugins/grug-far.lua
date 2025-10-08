return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      '<leader>sr',
      function()
        local grug = require 'grug-far'
        grug.open {
          windowCreationCommand = 'split',
        }
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
    },
  },
}
