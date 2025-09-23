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

-- TODO: Highlight trailing spaces
-- TODO: Command to trim whitespace
