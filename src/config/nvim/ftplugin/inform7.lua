-- For some reason, autoindentation isn't enabled in Inform files
vim.bo.autoindent = true
-- For some reason, whitespace indicators aren't enabled either
vim.wo.list = true
-- ...and linebreak settings
vim.wo.linebreak = true
-- Make sure this is set too
vim.opt_local.listchars = { tab = '->', trail = '·', nbsp = '␣', extends = '⨠' }
-- Override indentation size
vim.bo.expandtab = false
vim.bo.softtabstop = 0
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.textwidth = 0
