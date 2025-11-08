-- Source: <https://github.com/neovim/neovim/issues/32116>
local this_file = debug.getinfo(1, 'S').source:sub(2)

local already_loaded_once = false

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

local customize_colors = function()
  -- If the variable for base00 isn't defined, then we can assume the rest
  -- aren't defined, either
  if vim.g.tinted_gui00 ~= nil then
    if already_loaded_once then
      vim.notify('Reloading custom colors...', vim.log.levels.INFO)
    end

    vim.cmd('highlight TabLine guifg=' .. vim.g.tinted_gui04 .. ' guibg=' .. vim.g.tinted_gui02)
    vim.cmd('highlight TabLineSel guibg=' .. vim.g.tinted_gui00 .. ' gui=underline')
    vim.cmd('highlight NormalFloat guibg=' .. vim.g.tinted_gui01)
  end

  already_loaded_once = true
end

return {
  'tinted-theming/tinted-nvim',
  config = function()
    if vim.fn.executable 'tinty' == 0 then
      vim.notify(
        'Tinty is not installed. You can install it by exiting Vim, running `brew install tinted-theming/tinted/tinty`, then `tinty install`. Then make a new terminal session, run `tinty apply <name>,` and reload Vim.',
        vim.log.levels.ERROR
      )
      return
    end

    require('tinted-colorscheme').setup(nil, {})

    local autogroup = vim.api.nvim_create_augroup('custom-reload-colors', { clear = false })

    vim.api.nvim_create_autocmd('BufWritePost', {
      desc = 'Reload custom colors when updated',
      pattern = table.uniq {
        this_file,
        -- Even if we have the dotfiles repo open, the path of this file will be
        -- a symlink, so resolve it
        vim.fn.resolve(this_file),
      },
      group = autogroup,
      callback = customize_colors,
    })

    vim.api.nvim_create_autocmd('User', {
      desc = 'Load custom colors when updating Tinted theme',
      pattern = 'TintedColorsPost',
      group = autogroup,
      callback = customize_colors,
    })
  end,
}
