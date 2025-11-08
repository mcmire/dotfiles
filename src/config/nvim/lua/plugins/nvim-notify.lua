return {
  'rcarriga/nvim-notify',
  -- event = 'VeryLazy',
  --- @module 'notify'
  --- @type notify.Config
  opts = {
    render = 'wrapped-compact',
    stages = 'fade',
  },
  init = function()
    vim.notify = require 'notify'
  end,
}
