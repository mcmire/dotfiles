return {
  'yetone/avante.nvim',
  build = 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = 'gemini',
  },
}
