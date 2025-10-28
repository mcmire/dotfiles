return {
  'tinted-theming/tinted-nvim',
  config = function()
    local ansi_colorscheme = {
      -- Common
      cterm00 = '0',
      cterm08 = '1',
      cterm0B = '2',
      cterm0A = '3',
      ctermOD = '4',
      ctermOE = '5',
      ctermOC = '6',
      cterm05 = '7',
      cterm07 = '15',

      -- Base24
      cterm10 = '8',
      cterm12 = '9',
      cterm14 = '10',
      cterm13 = '11',
      cterm16 = '12',
      cterm17 = '13',
      cterm15 = '14',

      -- Base16
      -- cterm13 = '8',
      -- cterm08 = '9',
      -- cterm0B = '10',
      -- cterm0A = '11',
      -- cterm0D = '12',
      -- cterm0E = '13',
      -- cterm0C = '14',
    }

    require('tinted-colorscheme').setup(nil, {
      supports = {
        -- Don't rely on the current Tinty theme, always use the one above.
        -- tinty = false,
        -- live_reload = false,
      },
    })
  end,
}
