return {
  'nvim-mini/mini.nvim',
  config = function()
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
