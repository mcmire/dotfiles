-- For some reason, autoindentation isn't enabled in Markdown files
vim.bo.autoindent = true
-- For some reason, whitespace indicators aren't enabled either
vim.wo.list = true
-- Make sure this is set too
vim.opt.listchars = { tab = '->', trail = '·', nbsp = '␣', extends = '⨠' }
-- Override indentation size
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.textwidth = 80
