return {
  'duane9/nvim-rg',
  -- This plugin is small enough
  lazy = false,
  init = function()
    vim.g.rg_map_keys = false
  end,
  config = function()
    -- Old habits die hard
    vim.cmd 'cnoreabbrev Ack Rg'
  end,
}
