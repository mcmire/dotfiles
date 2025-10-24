-- ******************************
-- Options
-- ******************************

-- Always show line numbers
-- NOTE: Sometimes after Lazy opens, line numbers disappear.
-- We use an autocmd to fix this.
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Ensure line numbers are enabled',
  group = vim.api.nvim_create_augroup('custom-ensure-line-numbers', { clear = true }),
  callback = function()
    vim.o.number = true
  end,
})

-- Don't show splash screen when Vim starts
vim.opt.shortmess:append { I = true }

-- Allow project-level setting files ('secure' is on-demand)
vim.o.exrc = true

-- Treat dashes as valid word characters
vim.opt.iskeyword:append { '-' }

-- Don't load netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
