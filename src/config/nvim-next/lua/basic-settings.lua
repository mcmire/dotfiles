-- ******************************
-- Options
-- ******************************

-- Always show line numbers
-- NOTE: Sometimes after Lazy opens, line numbers disappear. Using `vim.go`
-- seems to solve it.)
vim.go.number = true

-- Don't show splash screen when Vim starts
vim.opt.shortmess:append { I = true }

-- Allow project-level setting files ('secure' is on-demand)
vim.o.exrc = true

-- Treat dashes as valid word characters
vim.opt.iskeyword:append { '-' }

-- Don't load netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
