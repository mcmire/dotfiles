return {
  'tinted-theming/tinted-nvim',
  config = function()
    require('tinted-colorscheme').setup(nil, {
      supports = {
        live_reload = true,
      },
    })
  end,
}
