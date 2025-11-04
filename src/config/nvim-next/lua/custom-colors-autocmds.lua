-- ******************************
-- Custom colors autocommands
-- ******************************

--- @generic T : table
--- @param values T
--- @return T
function table.uniq(values)
  local seen = {}
  local newtable = {}
  for _, value in ipairs(values) do
    if not seen[value] then
      table.insert(newtable, value)
      seen[value] = true
    end
  end
  return newtable
end

-- Source: <https://github.com/neovim/neovim/issues/32116>
local this_directory = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))

local custom_colors_file = this_directory .. '/custom-colors.lua'

-- When we're editing a file, new diagnostics and signs may appear and
-- disappear, and we don't want the sign column popping in and out
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Reload custom colors when updated',
  pattern = table.uniq {
    custom_colors_file,
    -- Even if we have the dotfiles repo open,
    -- `custom_colors_file` will be a symlink, so resolve it
    vim.fn.resolve(custom_colors_file),
  },
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
