-- ******************************
-- Custom colors autocommands
-- ******************************

-- Source: <https://github.com/neovim/neovim/issues/32116>
local this_directory = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
print('This directory: ' .. this_directory)

-- When we're editing a file, new diagnostics and signs may appear and
-- disappear, and we don't want the sign column popping in and out
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Reload custom colors when updated',
  -- At the moment just make this work, we will make this better later.
  pattern = {
    this_directory .. '/custom-colors.lua',
    vim.fn.expand '~' .. '/code/personal/dotfiles/src/config/nvim-next/lua/custom-colors.lua',
  },
  -- pattern = './custom-colors.lua',
  group = vim.api.nvim_create_augroup('custom-reload-colors', { clear = true }),
  callback = function()
    -- Hack Lua to "unload" this file
    package.loaded['custom-colors'] = nil
    require('custom-colors').customize_colors()
  end,
})

vim.api.nvim_create_autocmd('User', {
  desc = 'Load custom colors when updating Tinted theme',
  pattern = 'TintedColorsPost',
  group = vim.api.nvim_create_augroup('custom-adjust-colors', { clear = true }),
  callback = function()
    -- Hack Lua to "unload" this file
    package.loaded['custom-colors'] = nil
    require('custom-colors').customize_colors()
  end,
})
