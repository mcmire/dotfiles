return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Set up mini pick
    --[[
    require('mini.pick').setup {
      mappings = {
        move_down = '<C-j>',
        move_up = '<C-k>',
      },
      window = {
        config = {
          relative = 'editor',
          anchor = 'NW',
          row = 0,
          col = 0,
        },
      },
    }
    vim.keymap.set('n', '<C-p>', function()
      MiniPick.builtin.files()
    end)
    ]]

    -- Set status line
    local statusline = require 'mini.statusline'
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
    }
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
