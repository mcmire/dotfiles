-- ******************************
-- Options
-- ******************************

-- Don't show splash screen when Vim starts
vim.opt.shortmess:append { I = true }

-- Allow project-level setting files ('secure' is on-demand)
vim.o.exrc = true

-- Treat dashes as valid word characters
vim.opt.iskeyword:append { '-' }

-- Reduce updatetime
-- This also affects how fast CursorHold fires, which affects how fast words
-- under the cursor are highlighted (see `nvim-lspconfig.lua`)
vim.o.updatetime = 150

-- Don't load netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
