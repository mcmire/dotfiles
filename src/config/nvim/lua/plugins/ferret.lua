return {
  'wincent/ferret',
  -- It's already lazy
  lazy = false,
  init = function()
    -- Don't create keymaps; expect :Ack to be typed manually
    vim.g.FerretMap = 0
    -- Always sort by filepath
    vim.g.FerretExecutableArguments = {
      rg = '--vimgrep --no-heading --no-config --max-columns 4096 --sort=path',
    }
    -- Always show all results
    vim.cmd 'cnoreabbrev Ack Ack!'
  end,
}
