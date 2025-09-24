return {
  'calind/selenized.nvim',
  -- Load this before all of the other start plugins.
  priority = 1000,
  config = function()
    -- TODO: Figure out why we need to do this.
    vim.o.background = 'dark'
    vim.cmd 'colorscheme selenized'
  end,
}
