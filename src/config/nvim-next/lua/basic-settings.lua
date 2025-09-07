-- ******************************
-- Options
-- ******************************

-- Always show line numbers
vim.o.number = true

-- Don't show splash screen when Vim starts
vim.opt.shortmess:append { I = true }

-- Allow project-level setting files ('secure' is on-demand)
vim.o.exrc = true

-- Treat dashes as valid word characters
vim.opt.iskeyword:append { '-' }
