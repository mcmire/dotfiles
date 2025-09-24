-- ******************************
-- Whitespace settings
-- ******************************

-- Use soft tabs by default.
vim.o.expandtab = true
-- When pressing Tab, enter 2 spaces.
vim.o.softtabstop = 2
-- Indent by 2 spaces.
vim.o.shiftwidth = 2
-- Always render tabs as 2 spaces.
-- This means if a file has a mixture of tabs and spaces, the tabs will align
-- with the spaces.
vim.o.tabstop = 2

-- Highlight tabs, lines with nothing but spaces and spaces at the end of lines,
-- and lines that continue past the visible viewport.
vim.o.list = true
vim.opt.listchars = { tab = '⊢—', trail = '·', nbsp = '␣', extends = '⨠' }

-- Highlight whitespace at the end of a line,
-- both when loading a file and when entering input
local highlight_whitespace_augroup = vim.api.nvim_create_augroup('custom-highlight-whitespace', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, {
  group = highlight_whitespace_augroup,
  command = 'match ExtraWhitespace /\\s\\+$/',
})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = highlight_whitespace_augroup,
  command = 'match ExtraWhitespace /\\s\\+\\%#\\@<!$/',
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = highlight_whitespace_augroup,
  callback = function()
    vim.fn.clearmatches()
  end,
})

-- Source: http://vim.wikia.com/wiki/Remove_unwanted_spaces
local function trim_whitespace()
  vim.cmd '%s/\\s*$//'
  vim.cmd "normal! ''"
end
vim.keymap.set('n', '<Leader>tw', trim_whitespace, { desc = 'Trim whitespace' })
