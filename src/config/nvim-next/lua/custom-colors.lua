-- ******************************
-- Custom colors
-- ******************************

local M = {}

M.customize_colors = function()
  vim.cmd('highlight TabLine guifg=' .. vim.g.tinted_gui04 .. ' guibg=' .. vim.g.tinted_gui02)
  vim.cmd('highlight TabLineSel guibg=' .. vim.g.tinted_gui00 .. ' gui=underline')
end

return M
