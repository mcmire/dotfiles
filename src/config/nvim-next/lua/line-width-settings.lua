-- ******************************
-- Line width settings
-- ******************************

-- Wrap lines to 80 characters by default
-- (This comes from conventions for Ruby code, which probably comes from other
-- places like Unix)
vim.o.textwidth = 80

-- Draw vertical line at current `textwidth`
-- For some reason simply setting this option doesn't work,
-- we have to wait until a window is opened I guess
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Set color column',
  group = vim.api.nvim_create_augroup('custom-set-color-column', { clear = true }),
  callback = function()
    vim.o.colorcolumn = '+0'
  end,
})
